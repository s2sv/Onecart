class QuotesController < ApplicationController
  require "uri"
  require "net/http"

  before_action :authenticate_user!

  before_action :get_order
  before_action :get_quoteresponse, only: [:new, :create]

  # after_action :time_quote, only: [:new]

  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  before_action :set_margin

  # GET /quotes
  # GET /quotes.json
  def index
    #  @quotes = Quote.all
     @quotes = @order.quotes   
    
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  
  end

  # GET /quotes/new
  def new

    @quote = @order.quotes.build
    @showgif = false
     
      # @order.quotes.first.quote_response = response.read_body
      # puts @order.quotes.first.quote_response

     
      @quote_response = @response.read_body

      @parsed_json = JSON.parse(@response.read_body)
      @pretty_json = JSON.pretty_generate(@parsed_json)

      # cheapest
      # @a = JSON.pretty_generate(@parsed_json["third_party"]["fullfillment_options"][0])

      # Fastest
      

      puts @pretty_json

      if @parsed_json["message"].present?

        @noqmessage = "Unfortunatly, our rabbits could not fetch you any quote-carrots!"
        
        @why0 = "Here's why:"
        @why1 = JSON.pretty_generate(@parsed_json["message"]).to_s

            if JSON.pretty_generate(@parsed_json["validation_errors"][0]["errors"][0]).to_s.include?('picup')
              @why2 = JSON.pretty_generate(@parsed_json["validation_errors"][0]["errors"][0]).to_s.gsub! 'picup', 'order'
            else
              @why2 = JSON.pretty_generate(@parsed_json["validation_errors"][0]["errors"][0]).to_s
            end

            if JSON.pretty_generate(@parsed_json["validation_errors"][0]["errors"][1]).to_s.include?('picup')
              @why3 = JSON.pretty_generate(@parsed_json["validation_errors"][0]["errors"][1]).to_s.gsub! 'picup', 'order'
            else
              @why3 = JSON.pretty_generate(@parsed_json["validation_errors"][0]["errors"][1]).to_s
            end

            if JSON.pretty_generate(@parsed_json["validation_errors"][0]["key"]).to_s.include?('picup')
              @why4 = "Key: #{JSON.pretty_generate(@parsed_json["validation_errors"][0]["key"]).to_s.gsub! 'picup', 'order'}"
            else
              @why4 = "Key: #{JSON.pretty_generate(@parsed_json["validation_errors"][0]["key"]).to_s}"
            end

            if JSON.pretty_generate(@parsed_json["validation_errors"][0]["exceptions"][0]).to_s.include?('picup')
              @why5 = "Exceptions: #{JSON.pretty_generate(@parsed_json["validation_errors"][0]["exceptions"][0]).to_s.gsub! 'picup', 'order'}"
            else
              @why5 = "Exceptions: #{JSON.pretty_generate(@parsed_json["validation_errors"][0]["exceptions"][0]).to_s}"
            end
        
      else

      

              if @parsed_json["picup"]["valid"]

                if @parsed_json["picup"]["service_types"][0].present? && @parsed_json["picup"]["service_types"][1].present?

                    if @pbikequote = @parsed_json["picup"]["service_types"][0].present?

                      @pbikequote = @parsed_json["picup"]["service_types"][0]["price_incl_vat"].present?

                      @roundpbq = @parsed_json["picup"]["service_types"][0]["price_incl_vat"]*@margin
                      @pbikequote = @roundpbq.round(2)
                      @pbikeduration = @parsed_json["picup"]["service_types"][0]["duration"]

                      @noqflag1 = false

                      else
                      
                      @noqflag1 = true

                    end

                    if @pcarquote = @parsed_json["picup"]["service_types"][1].present?
                        # @pcarquote = @parsed_json["picup"]["service_types"][1]["price_incl_vat"].present?
                      @roundpcq = @parsed_json["picup"]["service_types"][1]["price_incl_vat"]*@margin
                      @pcarquote = @roundpcq.round(2)
                      @pcarduration = @parsed_json["picup"]["service_types"][1]["duration"]

                      @noqflag2 = false

                      else
                      
                      @noqflag2 = true

                    end

                  else

                    if @pvanquote = @parsed_json["picup"]["service_types"][0].present?

                      @pvanquote = @parsed_json["picup"]["service_types"][0]["price_incl_vat"].present?

                      @roundpvq = @parsed_json["picup"]["service_types"][0]["price_incl_vat"]*@margin
                      @pvanquote = @roundpvq.round(2)
                      @pvanduration = @parsed_json["picup"]["service_types"][0]["duration"]

                      @noqflag5 = false

                      else
                      
                      @noqflag5 = true

                    end

                end

                  else     

                    @noqmessage = "Unfortunatly, our rabbits could not fetch you any on-demand quotes."
                    @why0 = "Here's why:"
                    @why1 = "The most likely reason is that an external partner's systems are down..."

              end

              

              if @parsed_json["third_party"]["valid"]


                    if @tpcheapest = @parsed_json["third_party"]["fullfillment_options"][0]["price_incl_vat"].present?

                      @roundtpc = @parsed_json["third_party"]["fullfillment_options"][0]["price_incl_vat"]*@margin
                      @tpcheapest = @roundtpc.round(2)
                      @tc = @parsed_json["third_party"]["fullfillment_options"][0]["collected_before"].to_datetime
                      @tpcheapest_collect = @tc.strftime("%A %d %b at %I:%M %p")
                      @td = @parsed_json["third_party"]["fullfillment_options"][0]["delivered_before"].to_datetime
                      @tpcheapest_delivery = @td.strftime("%A %d %b at %I:%M %p")

                      @noqflag3 = false

                      else

                      @noqflag3 = true

                    end
                    
                    if @tpfastest = @parsed_json["third_party"]["fullfillment_options"][1]["price_incl_vat"].present?

                      @roundtpf = @parsed_json["third_party"]["fullfillment_options"][1]["price_incl_vat"]*@margin
                      @tpfastest = @roundtpf.round(2)
                      @tc1 = @parsed_json["third_party"]["fullfillment_options"][1]["collected_before"].to_datetime
                      @tpfastest_collect = @tc1.strftime("%A %d %b at %I:%M %p")
                      @td1 = @parsed_json["third_party"]["fullfillment_options"][1]["delivered_before"].to_datetime
                      @tpfastest_delivery = @td1.strftime("%A %d %b at %I:%M %p")

                      @noqflag4 = false

                      else

                      @noqflag4 = true

                    end

                else     

                  @noqmessage = "Unfortunatly, our rabbits could not fetch you any traditional quotes."
                  @why0 = "Here's why:"
                  @why1 = "The most likely reason is that an external partner's systems are down..."

              end

                
              if @parsed_json["picup"]["valid"] == false && @parsed_json["third_party"]["valid"] == false
                
                @noqmessage = "Unfortunatly, our rabbits could not fetch you any quote-carrots!"

                @why0 = "The most likely reason is:"
                @why2 = "We could not recognize one or both of the addresses..... PLEASE use our search functionality to 'search' and then 'select' an address."
                @why3 = "Note: Haastig makes use of google's geocoded addresses!" 
                @why4 = "Copying and pasting OR writing an address in your own creative way won't work ;)"
                @why5 = ""
                @showgif = true
              end
      
      end
      
      rescue => error

      puts error.inspect

      @noqmessage = "Unfortunatly, our rabbits could not fetch you any quote-carrots!"

      @why0 = "Here's why:"
      @why2 = "We could not recognize one or both of the addresses..... PLEASE use our search functionality to 'search' and then 'select' an address."
      @why3 = "Note: Haastig makes use of google's geocoded addresses!" 
      @why4 = "Copying and pasting OR writing an address in your own creative way won't work ;)"
      @why5 = ""
      @showgif = true


  end

  # GET /quotes/1/edit
  def edit
      
  end

  # POST /quotes
  # POST /quotes.json
  def create

    @quote = @order.quotes.build(quote_params)

    respond_to do |format|
      if @quote.save
        # format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.html { redirect_to order_quotes_path(@order), notice: 'Quoted price was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
 
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to order_quote_path(@order), notice: 'Quoted price was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy

     # Clear cart on Quote destroy

      current_basket.order_items.each do |order_item|

        if @quote.order_id.equal? order_item.order_id
      
        order_item.destroy
        end

      end

    @quote.destroy
    
    respond_to do |format|
      format.html { redirect_to order_path(@order), notice: 'Quoted price was successfully deleted.' }
      format.json { head :no_content }
    end

  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = @order.quotes.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quote_params
      params.require(:quote).permit(:price_incl_vat, :order_id, :quote_response, :vehicle_id)
    end

    def get_order
      @order = Order.find(params[:order_id])
    end

    def set_margin
      @margin = 1.3
    end

    def get_quoteresponse

     
      
      parcelstring = ""
      @order.parcels.each do |parcel|

      parcelstring = parcelstring + "{\n                    \"size\": \"#{parcel.size}\",\n                    \"reference\": \"#{parcel.reference}\",\n                    \"tracking_number\": null\n                },\n "
      # parcelstring = parcelstring + "{\n                    \"size\": \"#{parcel.size}\",\n                    \"reference\": \"quote-ref\",\n                    \"tracking_number\": null\n                },\n "

      end

      puts "PARCELS >> #{parcelstring}"

      # timestamp2 = Time.now + 3.hours
      timestamp = @order.scheduled_date.to_time - 2.hours
      puts "Parcel collection date/time >>>> #{timestamp}"

      envurl = ENV["PICUP_URL"]
      url = URI("https://#{envurl}/picup-api/v1/integration/quote/one-to-many")
      

      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["api-key"] = ENV["PICUP_API_KEY"]
      request.body = "{\n    \"merchant_id\": \"merchant-d827f668-d434-4ce5-b853-878f874ae746\",\n    \"customer_ref\": \"#{@order.customer_ref}\",\n    \"is_for_contract_driver\": false,\n    \"scheduled_date\": \"#{timestamp}\",\n    \"courier_costing\": \"ALL\",\n    \"sender\": {\n        \"address\": {\n            \"warehouse_id\": null,\n            \"unit_no\": #{@order.from_unit_no},\n            \"complex\": \"#{@order.from_complex}\",\n            \"street_or_farm_no\": #{@order.from_street_number},\n            \"street_or_farm\": \"#{@order.from_route}, \",\n            \"suburb\": \"#{@order.from_sublocality}\",\n            \"city\": \"#{@order.from_locality}\",\n            \"postal_code\": \"#{@order.from_postal_code}\",\n            \"country\": \"#{@order.from_country}\",\n            \"latitude\": #{@order.from_latitude},\n            \"longitude\": #{@order.from_longitude},\n            \"formatted_address\": null,\n        },\n        \"contact\": {\n            \"name\": \"#{@order.from_name}\",\n            \"email\": \"#{@order.from_email}\",\n            \"cellphone\": \"#{@order.from_phone}\"\n        },\n        \"special_instructions\": \"#{@order.from_special_instructions}\"\n    },\n    \"receivers\": [\n        {\n            \"address\": {\n                \"unit_no\": #{@order.to_unit_no},\n                \"complex\": \"#{@order.to_complex}\",\n                \"street_or_farm_no\": #{@order.to_street_number},\n                \"street_or_farm\": \"#{@order.to_route}\",\n                \"suburb\": \"#{@order.to_sublocality}\",\n                \"city\": \"#{@order.to_locality}\",\n                \"postal_code\": \"#{@order.to_postal_code}\",\n                \"country\": \"#{@order.to_country}\",\n                \"latitude\": #{@order.to_latitude},\n                \"longitude\": #{@order.to_longitude}\n            },\n            \"contact\": {\n                \"name\": \"#{@order.to_name}\",\n                \"email\": \"#{@order.to_email}\",\n                \"cellphone\": \"#{@order.to_phone}\"\n            },\n            \"special_instructions\": \"#{@order.to_special_instructions}\",\n            \"parcels\": [\n                #{parcelstring}            ]\n        }\n    ],\n    \"optimize_waypoints\": true\n}"
      puts request.body
      #   request.body = "{\n    \"merchant_id\": \"merchant-d827f668-d434-4ce5-b853-878f874ae746\",\n    \"customer_ref\": \"#{@order.customer_ref}\",\n    \"is_for_contract_driver\": false,\n    \"scheduled_date\": \"#{timestamp}\",\n    \"courier_costing\": \"ALL\",\n    \"sender\": {\n        \"address\": {\n            \"warehouse_id\": null,\n            \"unit_no\": #{@order.from_unit_no},\n            \"complex\": \"#{@order.from_complex}\",\n            \"street_or_farm_no\": #{@order.from_street_number},\n            \"street_or_farm\": \"#{@order.from_route}, \",\n            \"suburb\": \"#{@order.from_sublocality}\",\n            \"city\": \"#{@order.from_locality}\",\n            \"postal_code\": \"#{@order.from_postal_code}\",\n            \"country\": \"#{@order.from_country}\",\n            \"latitude\": #{@order.from_latitude},\n            \"longitude\": #{@order.from_longitude},\n            \"formatted_address\": null,\n        },\n        \"contact\": {\n            \"name\": \"#{@order.from_name}\",\n            \"email\": \"#{@order.from_email}\",\n            \"cellphone\": \"#{@order.from_phone}\"\n        },\n        \"special_instructions\": \"#{@order.from_special_instructions}\"\n    },\n    \"receivers\": [\n        {\n            \"address\": {\n                \"unit_no\": #{@order.to_unit_no},\n                \"complex\": \"#{@order.to_complex}\",\n                \"street_or_farm_no\": #{@order.to_street_number},\n                \"street_or_farm\": \"#{@order.to_route}\",\n                \"suburb\": \"#{@order.to_sublocality}\",\n                \"city\": \"#{@order.to_locality}\",\n                \"postal_code\": \"#{@order.to_postal_code}\",\n                \"country\": \"#{@order.to_country}\",\n                \"latitude\": #{@order.to_latitude},\n                \"longitude\": #{@order.to_longitude}\n            },\n            \"contact\": {\n                \"name\": \"#{@order.to_name}\",\n                \"email\": \"#{@order.to_email}\",\n                \"cellphone\": \"#{@order.to_phone}\"\n            },\n            \"special_instructions\": \"#{@order.to_special_instructions}\",\n            \"parcels\": [\n                {\n                    \"size\": \"#{@order.size}\",\n                    \"reference\": \"quote-ref\",\n                    \"tracking_number\": null\n                }\n            ]\n        }\n    ],\n    \"optimize_waypoints\": true\n}"
     

      @response = https.request(request)

      puts @response.read_body
    end

    # def time_quote
    #   o_id = @order.quotes.first.order_id  
    #   TimeWorker.perform_at(1.hours.from_now, o_id)
    #   puts "Quote will expire 1 hour from now."

   
    # end

end


