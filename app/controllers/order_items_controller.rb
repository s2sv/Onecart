class OrderItemsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_basket
 
  def create

    case route_to params

    when :single

      if current_basket.order_items.where(:order_id => basket_params[:order_id]).empty?

      @order_item = @basket.order_items.new(basket_params)
      @basket.save
      session[:basket_id] = @basket.id

      flash[:success] = 'You have successfully added the order to your cart!'

    else
      flash[:danger] = 'You have already added this order!'
    end
 
      redirect_to cart_path

    when :bucket
     
      
      puts " >>>>>>>> #{current_basket.order_items.where(:order_id => basket_params[:order_id]).empty?}"
      if current_basket.order_items.where(:order_id => basket_params[:order_id]).empty?
       

      @order_item = @basket.order_items.new(basket_params)
      @basket.save
      session[:basket_id] = @basket.id
      flash[:success] = 'You have successfully added the order to your cart!'

      else
        flash[:danger] = 'You have already added this order!'
      end

    end

  end



  def update
    @order_item = @basket.order_items.find(params[:id])
    @order_item.update_attributes(basket_params)
    @order_items = current_basket.order_items

   
  end

  def destroy
    @order_item = @basket.order_items.find(params[:id])
    @order_item.destroy
    @order_items = current_basket.order_items
  end

  private

  def basket_params
  params.require(:order_item).permit(:order_id, :quantity)
  end

  def set_basket
    @basket = current_basket
  end

  def route_to params
    params[:route_to].keys.first.to_sym
  end
  
end

