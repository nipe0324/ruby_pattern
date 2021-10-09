require_relative 'presenter'

class PostPresenter < Presenter
  def publication_status
    if object.published?
      "Published at #{published_at}"
    else
      "Unpublished"
    end
  end

  def published_at
    object.published_at.strftime("%A, %B %e")
  end
end
