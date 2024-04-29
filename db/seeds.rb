# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if User.exists?
    user = User.find_by(email: "admin@gmail.com")
    user.confirm if user && !user.confirmed?
  else
    user = User.create!(
      email: "admin@gmail.com", 
      password: "Railstester01", 
      approved: true, 
      isAdmin: true
    )
    user.skip_confirmation!
  end  