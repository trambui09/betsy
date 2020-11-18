require "test_helper"

describe Category do
  let (:new_category) {
    Category.new(name: "test category")
  }

  it "responds to the fields" do
    expect(new_category).must_respond_to :name
  end

  describe "relations" do
    it "can have many products" do
      new_category.save
      start_count = new_category.products.count

      products = [products(:product_one), products(:product_two), products(:product_three)]
      products.each do |product|
        new_category.products << product
      end

      new_category.products.each do |product|
        expect(product).must_be_instance_of Product
      end

      expect(new_category.products.count).must_equal start_count + 3

    end

  end

  describe "validations" do
    it "can instatinated a category" do
      expect(new_category.valid?).must_equal true
    end

    it "has to have a name" do
      new_category.name = nil

      expect(new_category.valid?).must_equal false
      expect(new_category.errors.messages).must_include :name
      expect(new_category.errors.messages[:name]).must_equal ["can't be blank"]
    end

  end
end
