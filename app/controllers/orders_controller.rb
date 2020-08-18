class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  
  # GET /orders
  # GET /orders.json
  def index

    
    if current_user.admin 

      @orders = Order.all.order("id DESC")
      @order_item = current_basket.order_items.new

    elsif current_user

      @orders = Order.where(:user_id => current_user).order("id DESC")
      @order_item = current_basket.order_items.new

      end 

  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order_item = current_basket.order_items.new
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit

  end

    # GET /orders/1/froma
  def froma
   @order = Order.find(params[:order_id])
  end

      # GET /orders/1/froma
  def toa
   @order = Order.find(params[:order_id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.user = current_user

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy

         # Clear cart on Order destroy

         current_basket.order_items.each do |order_item|

          if @order.quotes.first.order_id.equal? order_item.order_id
        
          order_item.destroy
          end
  
        end

    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Quote was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:scheduled_date, :processed, :title, :body, :size, :from_faddress, :from_address, :from_latitude, :from_longitude, :from_street_number, :from_route, :from_sublocality, :from_locality, :from_administrative_area_level_1, :from_postal_code, :from_country, :to_faddress, :to_address, :to_latitude, :to_longitude, :to_street_number, :to_route, :to_locality, :to_sublocality, :to_administrative_area_level_1, :to_postal_code, :to_country, :customer_ref, :is_for_contract_driver, :warehouse_id, :from_unit_no, :from_complex, :from_name, :from_email, :from_phone, :from_special_instructions, :to_unit_no, :to_complex, :to_name, :to_email, :to_phone, :to_special_instructions, :to_quote_ref, :parcel, parcels_attributes:[:id, :quantity, :order_id, :size, :reference,  :_destroy], quotes_attributes:[:id, :price_incl_vat, :order_id, :quote_response, :vehicle_id, :_destroy])
    end

end
