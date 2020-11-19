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
      @category_1 = Category.create(name: "food")
    end
    it "responds with success when getting the edit page for an existing, valid category" do

      # Act

      get edit_category_path(@category_1)

      # Assert
      must_respond_with :success
    end

  end

  describe "update" do
    before do
      Category.create!(name: "food")
    end
    let (:new_category_hash) {
      {category:
           {name: "gifts"}
      }
    }
    it "can update an existing category with valid information accurately, and redirect" do
      # Arrange

      id = Category.first.id


      # Act-Assert
      expect {
        patch category_path(id), params: new_category_hash
      }.wont_change 'Category.count'

      # Assert
      must_respond_with :redirect

      updated_category = Category.find_by(id: id)
      expect(updated_category.name).must_equal new_category_hash[:category][:name]

    end

    it "does not update any category if given an invalid id, and responds with a 404" do

      # Act-Assert
      expect {
        patch category_path(-1), params: new_category_hash
      }.wont_change 'Category.count'

      must_respond_with :not_found

    end
  end


end
