class CartController < ApplicationController

before_action :authenticate_user!

  def show
    @order_items = current_basket.order_items
  end

 

  def destroy
    session.delete(:basket_id)
    respond_to do |format|
      format.html { redirect_to cart_path, notice: 'Cart was cleared.' }
      format.json { head :no_content }
    end
  end

 end
