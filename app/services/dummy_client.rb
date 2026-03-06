# frozen_string_literal: true

# Cliente wrapper para la API de dummyjson.com.
# Centraliza las llamadas HTTP y expone métodos por recurso (users, todos, products, etc.).
# Documentación: https://dummyjson.com/docs
class DummyClient
  include HTTParty

  BASE_URL = "https://dummyjson.com"

  base_uri BASE_URL
  default_options.update(
    headers: { "Content-Type" => "application/json" },
    format: :json
  )

  class Error < StandardError; end
  class NotFoundError < Error; end
  class ApiError < Error; end

  # --- Users ---

  # @param id [Integer, String]
  # @return [Hash] usuario
  # @raise [NotFoundError] si el usuario no existe
  def user(id)
    get("/users/#{id}")
  end

  # @return [Hash] { "todos" => [...], "total" => N, "skip" => N, "limit" => N }
  def todos_by_user(user_id)
    get("/todos/user/#{user_id}")
  end

  private

  def get(path, options = {})
    request(:get, path, options)
  end

  def request(method, path, options = {})
    opts = options.dup
    opts[:headers] = (opts[:headers] || {}).merge(auth_headers)
    response = self.class.public_send(method, path, opts)
    parse_response(response, path)
  end

  def auth_headers
    return {} unless @access_token

    { "Authorization" => "Bearer #{@access_token}" }
  end

  def parse_response(response, path)
    body = response.parsed_response
    case response.code
    when 200..299
      body
    when 404
      raise NotFoundError, "Resource not found: #{path} (HTTP 404)"
    else
      raise ApiError, "Dummyjson.com error: #{response.code} - #{body}"
    end
  end
end
