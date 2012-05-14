module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Eventicator"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def errors_for(model, field)
    if (model.errors[field].present?)
      content_tag(:span, model.errors[field].join(', '), class: "field-errors alert alert-error")
    end
  end
end
