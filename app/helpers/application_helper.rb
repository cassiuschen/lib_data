module ApplicationHelper
  def page_title(title, is_root = false)
    if is_root
      title_str = title
    else
      title_str = "#{title} - "
    end

    content_for :title do
      title_str
    end
  end
end
