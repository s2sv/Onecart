class OrderItem < ApplicationRecord
  belongs_to :order 
  belongs_to :basket
  before_save :set_unit_price
  before_save :set_total
  

  def unit_price 
      # If there is a record
      if persisted?
          self[:unit_price]
      else
        order.quotes.first.price_incl_vat.to_f
      end
  end

  def total 
      return unit_price * quantity
  end

  private

  def set_unit_price
      self[:unit_price] = unit_price
  end
  def set_total
      self[:total] = total * quantity
  end 
  
 
  
end