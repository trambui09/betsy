module ApplicationHelper

  def safe_product_photo_url(product)
    product.photo_url || 'placeholder.jpg'
  end
end
