class Quote < ApplicationRecord
  belongs_to :order
  
  # validates :price_incl_vat, presence: true, uniqueness: true
end
