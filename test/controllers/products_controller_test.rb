require "test_helper"

describe ProductsController do

  before do
    @product = products(:product_one)
  end

  describe "logged in merchants" do
    before do
      perform_login(merchants(:merch_one))
      @merchant = merchants(:merch_one)
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
      # it 'can create a new product with valid information accurately, and redirect' do
      #   merchant = Merchant.create(username: "test merchant", email: "test@test.com")
      #   product_hash = {
      #       product: {
      #           merchant_id: merchant.id,
      #           name: "test product",
      #           price: 24.50,
      #           description: "testing description",
      #           photo_url: "testing.com",
      #           inventory_stock: 5
      #       }
      #   }
      #
      #   expect {
      #     post products_path, params: product_hash
      #   }.must_change "Product.count", 1
      #
      #   new_product = Product.find_by(name: product_hash[:product][:name])
      #
      #   expect(new_product.price).must_equal product_hash[:product][:price]
      #
      #   must_respond_with :redirect
      #   must_redirect_to product_path(new_product.id)
      #
      #
      # end
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

      let (:new_product_hash) {
        {
            product: {
                name: "testing name name",
                price: 25.50,
                description: "testing description",
                inventory_stock: 5,
                photo_url: "github.com",
                merchant_id: @merchant.id
            }
        }
      }

      it "can update an existing work" do
        # product = products(:product_two)

        expect {
          patch product_path(@product.id), params: new_product_hash
        }.wont_differ "Product.count"

        must_redirect_to product_path(@product.id)

        product = Product.find_by(id: @product.id)
        expect(product.name).must_equal new_product_hash[:product][:name]
      end

      it "would show not_found given an invalid id" do
        expect {
          patch product_path(-1), params: new_product_hash
        }.wont_differ "Product.count"

        must_respond_with :not_found
      end

      it " will not update if the params is invalid" do
        new_product_hash[:product][:name] = nil

        expect {
          patch product_path(@product.id), params: new_product_hash
        }.wont_differ "Product.count"

        @product.reload
        must_respond_with :bad_request
        expect(@product.name).wont_be_nil

      end
      # TODO: do we need to test for price validity
    end

    describe "toggle product status" do
      it "can change product from active to retire" do
        product = products(:product_one)
        expect(product.status).must_equal "active"

        post update_product_status_path(product.id)
        found_product = Product.find_by(name: "tree")
        expect(found_product.status).must_equal "retired"
      end

      it "can change product status from retire to active" do
        product = products(:product_seven)
        expect(product.status).must_equal "retired"

        post update_product_status_path(product.id)
        found_product = Product.find_by(name: "hot chocolate")
        expect(found_product.status).must_equal "active"

      end
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

      it "will show not_found for invalid product " do
        expect {
          delete product_path(-1)
        }.wont_differ "Product.count"

        must_respond_with :not_found
      end
    end
  end

  describe "guest users" do
    it "can access index" do
      get products_path
      must_respond_with :success
    end

    it "cannot access new" do
      get new_product_path
      must_redirect_to root_path
      flash[:error].must_equal "You must be logged in to do that"
    end

    it "cannot access edit" do
      get edit_product_path(@product.id)
      must_redirect_to root_path
      flash[:error].must_equal "You must be logged in to do that"
    end
  end
end
