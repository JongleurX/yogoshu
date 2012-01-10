module EntriesHelper

  def sprite_img(class_name)
    content_tag(:span, "", :class => "sprite-" + class_name, :style => "display: inline-block")
  end

end
