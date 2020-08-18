class Order < ApplicationRecord
  belongs_to :user
  has_many :parcels, dependent: :destroy
  accepts_nested_attributes_for :parcels
  has_many :quotes, dependent: :destroy
  accepts_nested_attributes_for :quotes
  has_many :order_items
end
