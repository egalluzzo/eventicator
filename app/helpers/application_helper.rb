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

  # Shows a map of the given address.
  def map_for(address, options = { height: '250',
                                   width: '100%',
                                   show_larger_map_link: true,
                                   larger_map_link_text: 'View Larger Map' })
    result = content_tag(:iframe, "",
                         width: options[:width],
                         height: options[:height],
                         frameborder: '0',
                         scrolling: 'no',
                         marginheight: '0',
                         marginwidth: '0',
                         src: "https://maps.google.com/?q=#{url_encode(address)}&ie=UTF8&t=m&z=15&output=embed")
    if options[:show_larger_map_link]
      result += tag(:br) + link_to(options[:larger_map_link_text],
                                   "https://maps.google.com/?q=#{url_encode(address)}&ie=UTF8&t=m&z=15&source=embed")
    end
    result
  end

  def errors_for(model, field)
    if (model.errors[field].present?)
      content_tag(:span, model.errors[field].join(', '), class: "field-errors alert alert-error")
    end
  end
end
