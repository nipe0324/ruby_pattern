require_relative 'post'
require_relative 'post_presenter'

post = Post.new('title', 'body', Time.now)
post_presenter = PostPresenter.decorate(post)
puts post_presenter.title #=> title
puts post_presenter.body #=> body
puts post_presenter.publication_status #=> Published at Saturday, October  9
