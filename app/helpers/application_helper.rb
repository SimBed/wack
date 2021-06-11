module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Wack'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def sortable(column, coltitle = nil, tooltiptitle = nil)
    coltitle ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : 'notcurrent'
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to coltitle, { sort: column, direction: direction },
            { title: tooltiptitle, 'data-toggle' => 'tooltip', class: css_class }
  end
end
