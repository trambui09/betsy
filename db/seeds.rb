# require 'faker'
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
    },
    {
        username: "jinglebell",
        email: "jinglebell@gmail.com",
        uid: 41,
        provider: "github"
    },
    {
        username: "candle",
        email: "candle@gmail.com",
        uid: 26,
        provider: "github"
    },
    {
        username: "reindeer",
        email: "reindeer@gmail.com",
        uid: 17,
        provider: "github"
    },
    {
        username: "snoopy",
        email: "snoopy@gmail.com",
        uid: 61,
        provider: "github"
    }

]

merchants.each do |merchant|
  Merchant.create(merchant)
end

products = [
    {
        name: "tree",
        price: 100.00,
        merchant_id: (Merchant.find_by username: "hohoho").id,
        photo_url: "placeholder.jpg"

    },
    {
        name: "sugar cookies",
        price: 2.30,
        merchant_id: (Merchant.find_by username: "merryx").id,
        photo_url: "placeholder.jpg"
    },
    {
        name: "ornament",
        price: 1.50,
        merchant_id: (Merchant.find_by username: "rednose").id,
        photo_url: "placeholder.jpg"
    },
    {
        name: "scarf",
        price: 3.99,
        merchant_id: (Merchant.find_by username: "jinglebell").id,
        photo_url: "placeholder.jpg"
    },
    {
        name: "pijama",
        price: 15.99,
        merchant_id: (Merchant.find_by username: "candle").id,
        photo_url: "placeholder.jpg"
    },
    {
        name: "chocolate",
        price: 3.59,
        merchant_id: (Merchant.find_by username: "reindeer").id,
        photo_url: "placeholder.jpg"
    },
    {
        name: "stocking",
        price: 8.90,
        merchant_id: (Merchant.find_by username: "snoopy").id,
        photo_url: "placeholder.jpg"
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


