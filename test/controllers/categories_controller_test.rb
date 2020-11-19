require "test_helper"

describe CategoriesController do
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

  describe "edit" do
    before do
      @category_1 = Driver.create(name: "food")
    end
    it "responds with success when getting the edit page for an existing, valid category" do

      # Act

      get edit_category_path(@category_1)

      # Assert
      must_respond_with :success
    end

  end
end
