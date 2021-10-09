# Presenter

An object-oriented layer of presentation logic.

## Inspired by

* [Draper](https://github.com/drapergem/draper)

## Example

```rb
post = Post.new('title', 'body', Time.now)

# Presenter
post_presenter = PostPresenter.decorate(post)

# delegate to post instance
puts post_presenter.title #=> title
puts post_presenter.body #=> body

# use presenter method
puts post_presenter.publication_status #=> Published at Saturday, October  9
```
