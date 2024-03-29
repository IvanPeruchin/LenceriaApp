# frozen_string_literal: true

# Modelo para representar los productos de la tienda
class ItemDescription < ActiveRecord::Base
  has_many :colors
  has_many :sizes
  belongs_to :item
end
