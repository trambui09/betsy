# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
merchants = [
    {
        username: "merryx",
        email: "merryx@gmail.com",
        uid: 1225,
        provider: "github"
    },
    {
        username: "hohoho",
        email: "santa@gmail.com",
        uid: 1,
        provider: "github"
    },
    {
        username: "rednose",
        email: "rednose@gmail.com",
        uid: 2,
        provider: "github"
    }
]

merchants.each do |merchant|
  Merchant.create!(merchant)
end

products = [
    {
        name: "tree",
        price: 100.00,
        merchant_id: (Merchant.find_by username: "hohoho").id
    },
    {
        name: "sugar cookies",
        price: 2.30,
        merchant_id: (Merchant.find_by username: "merryx").id
    },
    {
        name: "ornament",
        price: 1.50,
        merchant_id: (Merchant.find_by username: "rednose").id
    }
]

products.each do |product|
  Product.create(product)
end



categories = [
    {
        name: "decor"
    },
    {
        name: "food"
    },
    {
        name: "gifts"
    }
]

categories.each do |category|
  Category.create(category)
end




# cat1 = Category.create(name: "decor")
# cat2 = Category.create(name: "food")
# cat3 = Category.create(name: "gifts")



