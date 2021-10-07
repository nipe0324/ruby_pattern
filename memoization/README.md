# Memoization

Simple memoization patterns

## Inspired by

* [4 Simple Memoization Patterns in Ruby (And One Gem)](https://www.justinweiss.com/articles/4-simple-memoization-patterns-in-ruby-and-one-gem/)

## Example

### 1. Basic Pattern

```rb
class User
  def followers
    @followers ||= twitter_user.followers
  end
end

# Multi-line
class User
  def main_address
    @main_address ||= begin
      maybe_main_address = home_address if prefers_home_address?
      maybe_main_address ||= work_address
      maybe_main_address ||= addresses.first
    end
  end
end
```

### 2. Memoization with `nil?`

Use `defined?` to  instance variable.

```rb
class User
  def followers
    return @twitter_followers if defined?(@twitter_followers)

    @twitter_followers = twitter_user.followers
  end
end
```

### 3. Memoization with parameters

```rb
class City
  def self.top_cities(order_by)
    @top_cities ||= {}
    @top_cities[order_by] ||= where(top_city: true).order(order_by).to_a
    @top_cities[order_by]
  end
end
```
