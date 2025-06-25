# frozen_string_literal: true

module ApplicationHelper
  def full_title(title)
    base_title = 'TaskFlow'
    title.blank? ? base_title : "#{title} | #{base_title}"
  end

  def nav_link_to(name, path, html_class = '')
    active_class = current_page?(path) ? 'btn--active' : ''
    link_to name, path, class: "btn #{html_class} #{active_class}"
  end
end
