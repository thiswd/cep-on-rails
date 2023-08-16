# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
email = "jaiminho@correios.gov.br"
password = "tangamandapio"
user = User.new(email:, password:)

if user.save
  puts "User created"
  puts "Email: #{email}"
  puts "Password: #{password}"
else
  puts "Something went wrong"
  puts user.errors.full_messages.to_sentence
end
