require "test_helper"

describe CategoriesController do
  describe "logged in merchants" do
    before do
      perform_login(merchants(:merch_one))
    end

    describe "index" do
      it "responds with success when there are many categories saved" do
        # Arrange
        Category.create name: "food"
        # Act
        get categories_path
        # Assert
        must_respond_with :success
      end

      it "responds with success when there are no categories saved" do
        # Arrange

        # Act
        get categories_path
        # Assert
        must_respond_with :success
      end
    end


    describe "show" do
      # Arrange
      before do
        @category = Category.create(name: "food")
      end
      it "responds with success when showing an existing valid category" do
        # # Arrange

        id = @category.id
        # Act

        get categories_path(@category.id)

        # Assert
        must_respond_with :success

      end

      it "responds with 404 with an invalid category id" do
        # Act
        get category_path(-1)
        # Assert
        must_respond_with :not_found
      end
    end

    describe "new" do
      it "responds with success" do
        get new_category_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "can create a new category with valid information accurately, and redirect" do
        category_hash = {
            category: {
                name: "food"
            }
        }
        expect{
          post categories_path, params: category_hash
        }.must_change "Category.count", 1

        new_category = Category.find_by(name: category_hash[:category][:name])

        expect(new_category.name).must_equal category_hash[:category][:name]
        must_respond_with :redirect
        # must_redirect_to category_path(new_category.id)
      end
    end

    # describe "edit" do
    #   before do
    #     @category_1 = Category.create(name: "food")
    #   end
    #   it "responds with success when getting the edit page for an existing, valid category" do
    #
    #     # Act
    #
    #     get edit_category_path(@category_1)
    #
    #     # Assert
    #     must_respond_with :success
    #   end
    #
    # end
    #
    # describe "update" do
    #   before do
    #     Category.create!(name: "food")
    #   end
    #   let (:new_category_hash) {
    #     {category:
    #          {name: "gifts"}
    #     }
    #   }
    #   it "can update an existing category with valid information accurately, and redirect" do
    #     # Arrange
    #
    #     id = Category.first.id
    #
    #
    #     # Act-Assert
    #     expect {
    #       patch category_path(id), params: new_category_hash
    #     }.wont_change 'Category.count'
    #
    #     # Assert
    #     must_respond_with :redirect
    #
    #     updated_category = Category.find_by(id: id)
    #     expect(updated_category.name).must_equal new_category_hash[:category][:name]
    #
    #   end
    #
    #   it "does not update any category if given an invalid id, and responds with a 404" do
    #
    #     # Act-Assert
    #     expect {
    #       patch category_path(-1), params: new_category_hash
    #     }.wont_change 'Category.count'
    #
    #     must_respond_with :not_found
    #
    #   end
    # end

  end

  describe "guest users" do

  end

end
