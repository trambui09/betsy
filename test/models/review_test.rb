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
    it "must have a rating between 1-5" do
      new_review.rating = 7

      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_equal ["rating must be between 1-5"]

    end

  end

  describe "relations" do
    before do
      @review_1 = Review.new(rating: 4,
                             description: "Good enough")
    end

    it "can set the product using Product" do
      @review_1.product = @product

      expect(@review_1.product_id).must_equal @product.id
    end

    it "can set the product using product_id" do

      @review_1.product_id = @product.id

      expect(@review_1.product).must_equal @product
    end

  end

end
