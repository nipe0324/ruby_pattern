# HTTP Router

Define HTTP Router by DSL

## Inspired by

* [Hanami::Router](https://github.com/hanami/router)

## Example

* Define HTTP routing

```rb
# config.ru
app = Router.new do
  root to: ->(env) { [200, {}, ["Hello, Router"]] }
  get "/books/:id", to: Books::Show
end

run app
```

* Start server

```bash
$ rackup
Puma starting in single mode...
* Puma version: 5.5.0 (ruby 2.6.5-p114) ("Zawgyi")
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 12317
* Listening on http://127.0.0.1:9292
* Listening on http://[::1]:9292
Use Ctrl-C to stop
```

* Request

```bash
$ curl http://127.0.0.1:9292/
Hello, Router

$ curl http://127.0.0.1:9292/books/1
Books Show with {:id=>"1"}
```
