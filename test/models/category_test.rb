require "test_helper"

describe Category do
  let (:new_category) {
    Category.new(name: "test category")
  }

  it "responds to the fields" do
    expect(new_category).must_respond_to :name
  end

  describe "relations" do

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
