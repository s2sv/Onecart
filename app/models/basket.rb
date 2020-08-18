class Basket < ApplicationRecord
    has_many :order_items
    before_save :set_subtotal

    def subtotal 
        order_items.collect {|order_item| order_item.valid? ? order_item.unit_price * order_item.quantity : 0}.sum #turnairy?
    end

    def orderlist

        orderlist = ""
        pre = "Order(s) ID(s): "

        order_items.each do |item| 
            orderlist = orderlist + "["+ item.order_id.to_s + "] "
        end

        orderlist = pre + orderlist 

        return orderlist

    end

    private
    def set_subtotal
        self[:subtotal] = subtotal
    end
end