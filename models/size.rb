# frozen_string_literal: true

# Modelo para representar los productos de la tienda
class Size < ActiveRecord::Base
  has_many :item_descriptions
end
