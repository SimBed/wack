require 'test_helper'

class SchedulingsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:lana)
    @workout = workouts(:workouttwo)
  end

  test "valid input for new scheduling (for pre-defined Wack)" do
    log_in_as(@user)
    # ActiveSupport::TimeWithZone rather than a similar Time object for consistency with the database field start_time
    t = Time.zone.now.advance(days: 3)
    workout_name = Workout.find(@workout.id).name
    assert_difference '@user.schedulings.count', 1 do
      # scheduling name will get set in controller
      # request.referrer is nil in test environment, headers approach above is a workaround
      post schedulings_path, params: { scheduling: { start_time: t },
                                       workout_id: @workout.id  } ,
                             headers: { "HTTP_REFERER" => "http://www.example.com/workouts" }
    end

    assert_redirected_to workouts_url
    follow_redirect!
    assert_template 'workouts/index'
    assert_not flash.empty?
    # attempted explicit match of the date text within a td but encountered unresolved oddity
    # in the html produced for days in the calendar with events...see the chrome inspector
    # ...the date is surrounded by mysterious quotation marks (unlike dates without events).
    #  Couldn't understand what this was or how it got there (it is not there in the response
    # body output which I tried writing to file to interrogate.

    # assert_select 'td', Time.now.advance(days: 1).strftime("%d/%m")
    # assert_match t.strftime("%d/%m"), response.body
    # assert_match /10\/11/, response.body
    # target = open("test.txt", 'w')
    # target.write(response.body)
    # target.close

    # the html looks something like:
    # <td> 19/11 </td>
    # <td>" 20/11 "<div>wack</div> </td>
    # My workaround was to search  by REGEXS instead)

    # on 29 December, the test failed. 3 days advanced is 1 Jan, where t.day returns 1 not 01 required, hence the change in code.
    # assert_select "td", {text: /#{t.day}\/#{t.month}/}, true do

    # assert_select "td", {text: /#{t.strftime("%d/%m")}/}, true do
      # assert_select "div", {text: workout_name}, true
    # end

    get schedulings_path

    # the hash is only needed for multiple equality tests. I retained this syntax (above) only for that
    # assert_select but not thereafter. Likewise the true (above) is not necessary as it is the  default.
    # assert_select "td", /#{t.day}\/#{t.month}/ do
    # assert_select "    # assert_select "td", /#{t.strftime("%d/%m")}/ do
    #   assert_select "div", workout_name
    # endtd", /#{t.strftime("%d/%m")}/ do
    #   assert_select "div", workout_name
    # end

    # see my stackoverflow question - experimented with how to match
    # <tr> <td> name </td> <td> date </td> </tr>
    # ended up finding a regexs was the simplest approach
    # ~ is the css general sibling combinator. eg css_select "td~td" matches tds that are siblings of and subsequent to any td (so it wouldn't include the first td). Didn't end up using this.
    t1 = t.strftime('%Y-%m-%d, %H:%M')
    # pars has class Nokogiri::XML::NodeSet
    pars = css_select "tr"
    # pars.each_with_index{ |val,index| puts "index: #{index} for #{val}" }
    regexs = /<td>#{workout_name}<\/td>.*<td>#{t1}<\/td>.*Show.*Edit.*Delete/m
    match = false
    pars.each { |i| if i.to_s =~ regexs then match = true end }
    assert match

    # Edit the scheduling
    @latest_scheduling = Scheduling.order(created_at: :desc).first

    # show a scheduling via a specified route (so session[:linked_from] is not nil)
    # unsure why using a helper in the same way as log_in_as didn't work
    get scheduling_path(@latest_scheduling), params: { linked_from: :welcome  }
    get edit_scheduling_path(@latest_scheduling)
    assert_template 'schedulings/edit'
    t1 = t.advance(days: 1)
    patch scheduling_path(@latest_scheduling), params: { scheduling: { start_time: t1  } }
    assert_redirected_to scheduling_path(@latest_scheduling)
    follow_redirect!
    assert_not flash.empty?
    # assert_select "td", {text: /#{t.strftime("%d/%m")}/}, true do
    #   assert_select "div", false
    # end
    @latest_scheduling.reload
    # strange millisecond discrepancies occur comparing Ruby generated Times against database stored Times
    # hence the conversion to string before the comparison
    # puts (t + 60 * 60 * 24).strftime('%Y-%m-%d %H:%M:%S.%L')
    # puts @latest_scheduling.start_time.strftime('%Y-%m-%d %H:%M:%S.%L')
    assert_equal t.advance(days: 1).to_s,  @latest_scheduling.start_time.to_s
    # t.day + 1 directly into the curly brackets in the REGEXS failed
    # t1_day = t.day + 1

    # assert_select "td", /#{t1.day}\/#{t1.month}/ do
    # assert_select "td", /#{t1.strftime("%d/%m")}/ do
    #   assert_select "div", workout_name
    # end

    # Delete the scheduling
    assert_difference '@user.schedulings.count', -1 do
      delete scheduling_path(@latest_scheduling)
    end
    assert_redirected_to schedulings_path
    follow_redirect!
    assert_not flash.empty?
    # assert_select "td", {text: /#{t1.strftime("%d/%m")}/}, true do
    #   assert_select "div", false
    # end

  end

  test "valid input for new scheduling (for bespoke Wack)" do
    log_in_as(@user)
    t = Time.zone.now.advance(minutes: 5)
    assert_difference '@user.schedulings.count', 1 do
      post schedulings_path, params: { scheduling: { name: "skipjump", start_time: t }},
                             headers: { "HTTP_REFERER" => "http://www.example.com/schedulings" }

    end

    assert_redirected_to schedulings_url
    follow_redirect!
    assert_template 'schedulings/index'
    assert_not flash.empty?

    # assert_select "td", {text: /#{t.strftime("%d/%m")}/}, true do
    #   assert_select "div", "skipjump"
    # end

    assert_select "tr" do
      assert_select "td", "skipjump"
      assert_select "td", t.strftime('%Y-%m-%d, %H:%M')
    end

  end

end
