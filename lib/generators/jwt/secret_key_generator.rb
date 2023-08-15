module Jwt
  class SecretKeyGenerator < Rails::Generators::Base
    desc "Generate a secret key and save it to .env file"

    def generate_secret_key
      secret_key = SecureRandom.hex(64)
      puts "Generated Secret Key: #{secret_key}"

      env_file_path = Rails.root.join('.env')
      File.open(env_file_path, 'a') do |f|
        f.puts "DEVISE_JWT_SECRET_KEY=#{secret_key}"
      end

      puts 'Secret Key has been saved to .env file.'
    end
  end
end
