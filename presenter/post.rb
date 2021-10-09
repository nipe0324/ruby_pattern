class Post
  attr_reader :title, :body, :published_at

  def initialize(title, body, published_at = nil)
    @title = title
    @body = body
    @published_at = published_at
  end

  def published?
    !@published_at.nil?
  end
end
