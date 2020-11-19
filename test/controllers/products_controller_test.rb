require "test_helper"

describe ProductsController do
  before do
    @product = products(:product_one)
  end

  describe 'index' do
    it "gets index" do
      get "/products"
      must_respond_with :success
    end
  end

  describe "show" do
    it "can get to the product show page" do
      get product_path(@product.id)

      must_respond_with :success

    end

    it "will show not_found when given an invalid product id " do
      get product_path(-1)

      must_respond_with :not_found
    end

  end

  describe 'new' do
    it 'can get the new product path' do
      get new_product_path

      must_respond_with :success
    end
  end

  describe 'create' do
    it 'can create a new product with valid information accurately, and redirect' do
      merchant = Merchant.create(username: "test merchant", email: "test@test.com")
      product_hash = {
          product: {
              merchant_id: merchant.id,
              name: "test product",
              price: 24.50,
              description: "testing description",
              photo_url: "testing.com",
              inventory_stock: 5
          }
      }

      expect {
        post products_path, params: product_hash
      }.must_change "Product.count", 1

      new_product = Product.find_by(name: product_hash[:product][:name])

      expect(new_product.price).must_equal product_hash[:product][:price]

      must_respond_with :redirect
      must_redirect_to product_path(new_product.id)


    end
  end

  describe "edit" do
    it "can get to the product edit page" do
      get edit_product_path(@product.id)

      must_respond_with :success

    end

    it "will return not_found if product id is invalid" do
      get edit_product_path(-1)

      must_respond_with :not_found
    end

  end

  describe "update" do

  end


  describe "destroy" do
    before do
      merchant = Merchant.create(username: "test merchant", email: "test@test.com")
      Product.create!(merchant: merchant, name: "test", price: 1.99, description: "test description", photo_url: "www.test.com", inventory_stock: 15)
    end

    it "destroys the product instance in db when product exists, then redirects" do
      # Arrange


      id = Product.find_by(name: "test")[:id]
      # id = trip.id
      # Act
      expect {
        delete product_path(id)
      }.must_change "Product.count", -1

      deleted_product = Product.find_by(name: "test", price: 1.99)

      # Assert
      expect(deleted_product).must_be_nil
      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

end
