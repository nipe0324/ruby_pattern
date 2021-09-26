require_relative 'router'
require_relative 'controllers/books_show'

app = Router.new do
  root to: ->(env) { [200, {}, ["Hello, Router"]] }
  get "/books/:id", to: Books::Show
end

run app
