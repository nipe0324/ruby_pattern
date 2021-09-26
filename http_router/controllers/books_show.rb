module Books
  class Show
    def self.call(env)
      params = env["router.params"]

      [200, {}, ["Books Show with #{params.inspect}"]]
    end
  end
end
