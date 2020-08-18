class ParcelsController < ApplicationController


  before_action :authenticate_user!

  before_action :get_order

  before_action :set_parcel, only: [:show, :edit, :update, :destroy]


  # GET /quotes
  # GET /quotes.json
  def index
    #   @quotes = @order.quotes   
     @parcels = @order.parcels   
    
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  
  end

  # GET /quotes/new
  def new

    
    #@quote = @order.quotes.build
    @parcel = @order.parcels.build
     
      # @order.quotes.first.quote_response = response.read_body
      # puts @order.quotes.first.quote_response

     




  end

  # GET /quotes/1/edit
  def edit
      
  end

  # POST /quotes
  # POST /quotes.json
  def create

    #@quote = @order.quotes.build(quote_params)
    @parcel = @order.parcels.build(parcel_params)

    respond_to do |format|
      if @parcel.save
        format.html { redirect_to order_parcels_path(@order), notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html { render :new }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
 
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @parcel.update(parcel_params)
        format.html { redirect_to order_parcel_path(@order), notice: 'Parcel was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcel }
      else
        format.html { render :edit }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy

     # Clear cart on Quote destroy

      current_basket.order_items.each do |order_item|

        if @parcel.order_id.equal? order_item.order_id
      
        order_item.destroy
        end

      end

    @parcel.destroy
    
    respond_to do |format|
      format.html { redirect_to order_path(@order), notice: 'Parcel was successfully deleted.' }
      format.json { head :no_content }
    end

  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_parcel
      #@quote = @order.quotes.find(params[:id])
      @parcel = @order.parcels.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parcel_params
      params.require(:parcel).permit(:quantity, :order_id, :size)
    end

    def get_order
      @order = Order.find(params[:order_id])
    end

end


