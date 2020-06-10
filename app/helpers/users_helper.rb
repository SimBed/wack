module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

 # Returns a shortened date format for easier reading in list
 def date_reformat(date)
   word_date = '%d/%m/%y'
   date.nil? ?  "-" : date.strftime(word_date)
 end

end
