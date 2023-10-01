module Jwt
  class SecretKeyGenerator < Rails::Generators::Base
    desc "Generate a secret key and save it to .env file"

    def generate_secret_key
      env_file_path = Rails.root.join(".env")

      if secret_key_defined?(env_file_path)
        puts "DEVISE_JWT_SECRET_KEY is already defined in .env."
        return unless yes?("Do you want to override the existing secret key? (yes/no)")

        remove_existing_secret_key(env_file_path)
      end

      secret_key = SecureRandom.hex(64)
      puts "Generated Secret Key: #{secret_key}"

      File.open(env_file_path, "a") do |f|
        f.puts "DEVISE_JWT_SECRET_KEY=#{secret_key}"
      end

      puts "Secret Key has been saved to .env file."
    end

    private

      def secret_key_defined?(env_file_path)
        File.read(env_file_path).include?("DEVISE_JWT_SECRET_KEY")
      end

      def remove_existing_secret_key(env_file_path)
        content = File.readlines(env_file_path).delete_if { |line| line.include?("DEVISE_JWT_SECRET_KEY") }
        File.write(env_file_path, content.join)
      end
  end
end
