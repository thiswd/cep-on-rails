# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"
    resource(
      "/api/*",
      headers: %w[Authorization],
      expose: ["access-token", "expiry", "token-type", "Authorization"],
      methods: [:get, :delete, :post, :options, :show]
    )
  end
end
