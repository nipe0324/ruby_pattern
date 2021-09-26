# frozen_string_literal: true

require "rack/utils"
require_relative 'router/params'
require_relative 'router/prefix'
require_relative 'router/trie'

class Router
  attr_reader :routes

  def initialize(base_url: DEFAULT_BASE_URL, prefix: DEFAULT_PREFIX, resolver: DEFAULT_RESOLVER, not_found: NOT_FOUND, &block)
    @base_url = base_url
    @path_prefix = Prefix.new(prefix)
    @resolver = resolver
    @not_found = not_found
    @block = block

    @globbed = {}
    @variable = {}
    @fixed = {}

    instance_eval(&block) if block
  end

  def call(env)
    endpoint, params = lookup(env)

    return not_found(env) unless endpoint

    endpoint.call(_params(env, params)).to_a
  end

  def root(to: nil, &block)
    get("/", to: to, as: :root, &block)
  end

  def get(path, to: nil, **constraints, &block)
    add_route("GET",  path, to, constraints, &block)
    add_route("HEAD", path, to, constraints, &block)
  end

  def post(path, to: nil, **constraints, &block)
    add_route("POST",  path, to, constraints, &block)
  end

  private

  DEFAULT_BASE_URL = "http://localhost"
  DEFAULT_PREFIX = "/"
  DEFAULT_RESOLVER = ->(_, to) { to }
  NOT_FOUND = ->(*) { [404, {"Content-Length" => "9"}, ["Not Found"]] }.freeze
  PARAMS = "router.params"

  def lookup(env)
    endpoint = fixed(env)
    return [endpoint, {}] if endpoint

    variable(env) || globbed(env)
  end

  def fixed(env)
    @fixed.dig(env["REQUEST_METHOD"], env["PATH_INFO"])
  end

  def variable(env)
    @variable[env["REQUEST_METHOD"]]&.find(env["PATH_INFO"])
  end

  def globbed(env)
    @globbed[env["REQUEST_METHOD"]]&.each do |path, to|
      if (match = path.match(env["PATH_INFO"]))
        return [to, match.named_captures]
      end
    end

    nil
  end

  def _params(env, params)
    params ||= {}
    env[PARAMS] ||= {}
    env[PARAMS].merge!(Rack::Utils.parse_nested_query(env["QUERY_STRING"]))
    env[PARAMS].merge!(params)
    env[PARAMS] = Params.deep_symbolize(env[PARAMS])
    env
  end

  def add_route(http_method, path, to, constraints, &block)
    path = prefixed_path(path)
    to = resolve_endpoint(path, to, block)

    if globbed?(path)
      add_globbed_route(http_method, path, to, constraints)
    elsif variable?(path)
      add_variable_route(http_method, path, to, constraints)
    else
      add_fixed_route(http_method, path, to)
    end
  end

  def prefixed_path(path)
    @path_prefix.join(path).to_s
  end

  def resolve_endpoint(path, to, block)
    (to || block) or raise ArgumentError, "Missing endpoint: #{path}"
    to = Block.new(@block_context, block) if to.nil?

    @resolver.call(path, to)
  end

  def globbed?(path)
    /\*/.match?(path)
  end

  def variable?(path)
    /:/.match?(path)
  end

  def add_globbed_route(http_method, path, to, constraints)
    @globbed[http_method] ||= []
    @globbed[http_method] << [Segment.fabricate(path, **constraints), to]
  end

  def add_variable_route(http_method, path, to, constraints)
    @variable[http_method] ||= Trie.new
    @variable[http_method].add(path, to, constraints)
  end

  def add_fixed_route(http_method, path, to)
    @fixed[http_method] ||= {}
    @fixed[http_method][path] = to
  end

  def not_found(env)
    @not_found.call(env)
  end
end
