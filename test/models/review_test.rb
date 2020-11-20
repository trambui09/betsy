require "test_helper"

describe Review do
  before do
    @product = products(:product_one)
  end
  let (:new_review) {
    Review.new(rating: 5,
               description: "great overall",
               product_id: @product.id)
  }

  it "can instantiated a review" do
    expect(new_review.valid?).must_equal true
  end

  it "responds to its fields" do
    new_review.save
    review = Review.first

    [:rating, :description].each do |field|
      expect(review).must_respond_to field
    end
  end

  describe "validations" do

  end

  describe "relations" do

  end
  
end
