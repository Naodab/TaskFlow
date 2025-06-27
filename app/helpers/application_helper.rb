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

  def form_label_with_error(form, field, label_text = nil, options = {})
    error = form.object.errors[field].first
    base_label = label_text || field.to_s.humanize

    default_class = 'form-label'
    error_class = error.present? ? 'form-error' : ''
    label_class = [default_class, options[:class], error_class].compact.join(' ')

    if error
      form.label field, class: label_class do
        raw("#{base_label} <span class='form-error-msg'>#{error}</span>")
      end
    else
      form.label field, base_label, class: label_class
    end
  end
end
