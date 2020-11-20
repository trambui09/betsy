# require "faker"
# require "csv"
# require "date"
#
# CSV.open("products-seeds.csv", "w", :write_headers => true,
#          :headers => ["name", "price", "description", "photo_url", "inventory_stock", ""]) do |csv|
#   40.times do
#     name = Faker::Coffee.blend_name
#     price = Faker::Number.decimal(l_digits: 2)
#     description = Faker::Lorem.sentence
#     photo_url = "www.photourl.com"
#     inventory_stock = Faker::Number.number
#
#
#
#     csv << [name, price, description, inventory_stock]
#   end
# end