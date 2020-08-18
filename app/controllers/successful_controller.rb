class SuccessfulController < ApplicationController

  require "uri"
  require "net/http"

  # before_action :authenticate_user!
  before_action :set_orders

  after_action :new_basket


  def show

    @orders.each do |order|
      puts "This is a sanity check: ...... #{order.id}"
    end

    @orders.each do |order| #------------------------------- Dictate which order to place


      json = order.quotes.first.quote_response
      parsed_json = JSON.parse(json)

      if order.quotes.first.vehicle_id == "vehicle-cheap" && order.processed == false # Cheapest

          new_body = parsed_json["third_party"]["fullfillment_options"].delete_at(0)
          couriercode = new_body["collections"][0]["courier_code"]
          new_body["collections"][0]["collection"]["waybill"]["courier_code"] = couriercode
        
        
          puts couriercode
          

          puts JSON.pretty_generate(new_body)
          send_tcreateresponse(new_body["collections"][0], order) # Cheapest
          puts "INSIDE CHEAP IF __________________________________________________________________________________________________"

        elsif order.quotes.first.vehicle_id == "vehicle-fast" && order.processed == false  # Fastest

          # Fastest
          new_body = parsed_json["third_party"]["fullfillment_options"].delete_at(1)
          couriercode = new_body["collections"][0]["courier_code"]
          new_body["collections"][0]["collection"]["waybill"]["courier_code"] = couriercode
        
        
          puts couriercode

          puts JSON.pretty_generate(new_body)
          send_tcreateresponse(new_body["collections"][0], order) # Fastest
          puts "INSIDE FAST IF __________________________________________________________________________________________________"

        elsif (order.quotes.first.vehicle_id == "vehicle-motorcycle" || order.quotes.first.vehicle_id == "vehicle-car" || order.quotes.first.vehicle_id == "vehicle-small-van") && order.processed == false # Motorcyle / Car / Van

            parsed_json["request"]["vehicle_id"] = order.quotes.first.vehicle_id

            # timestamp = Time.now + 15.minutes
            # parsed_json["request"]["scheduled_date"] = timestamp
            
            puts parsed_json["request"]["scheduled_date"]

            new_body = parsed_json["request"]
          
            puts JSON.pretty_generate(new_body)
          
            send_pcreateresponse(new_body, order) # Motorcyle / Car / Van
            puts "INSIDE PICUP IF __________________________________________________________________________________________________"

        else 

          puts ">>>>>> DO NOTHING!"

      end



      #---------------------------------- DISPLAY RESULTS


        @get_response = order.body

        
        
        puts "this is the response #{@get_response}"
      

        
        # @order_response = @response.read_body

        puts JSON.parse(@get_response)
        @parsed_response = JSON.parse(@get_response)
        puts JSON.pretty_generate(@parsed_response)


        puts @parsed_response["message"]

      if @parsed_response["message"].present?

          @message = "Unfortunatly, our rabbits could not place your order(s)! Please contact support on our webchat or at support@haastig.com"
          
          @why0 = "Here's why:"
          @why1 = JSON.pretty_generate(@parsed_response["message"]).to_s

          if JSON.pretty_generate(@parsed_response["validation_errors"][0]["errors"][0]).to_s.include?('picup')
            @why2 = JSON.pretty_generate(@parsed_response["validation_errors"][0]["errors"][0]).to_s.gsub! 'picup', 'order'
          else
            @why2 = JSON.pretty_generate(@parsed_response["validation_errors"][0]["errors"][0]).to_s
          end

          if JSON.pretty_generate(@parsed_response["validation_errors"][0]["errors"][1]).to_s
            @why3 = JSON.pretty_generate(@parsed_response["validation_errors"][0]["errors"][1]).to_s.gsub! 'picup', 'order'
          else
            @why3 = JSON.pretty_generate(@parsed_response["validation_errors"][0]["errors"][1]).to_s
          end

        else

          @message = "Your Order(s) were processed successfully."

          if @parsed_response["picup_id"]

            @success = JSON.pretty_generate(@parsed_response["picup_id"]).to_s.gsub! 'picup', 'order'
            @picupid = JSON.pretty_generate(@parsed_response["picup_id"]).to_s

          else

            @success = JSON.pretty_generate(@get_response)
           
        end
            
      end

      # note @parsed_json["request"]["customer_ref"] is handled with original request
    
    end

            # Tell the UserMailer to send a welcome email after save
            valueF = true
            clear_basket(valueF)
  end


  private

  def set_orders

    # @orders = Order.where(:user_id => current_user)
    @orders = Order.where(:id => current_basket.order_items.map{|h| h.order_id })

  end

  def send_pcreateresponse(newbody, order)

      envurl = ENV["PICUP_URL"]
      url = URI("https://#{envurl}/picup-api/v1/integration/create/one-to-many")

      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["api-key"] = ENV["PICUP_API_KEY"]
      request.body = newbody.to_json

      response = https.request(request)
     

      response.read_body
      puts response.read_body
    
        order.update(body: response.read_body)
        order.update(title: order.quotes.first.vehicle_id)
        # update processed status on succesful payment
        order.update(processed: true)
 
      puts "PICUP ON_DEMAND ORDER CREATED!!!!!!!!!"

      pcr_response = order.body
      
      pcr_parced = JSON.parse(pcr_response)
      JSON.pretty_generate(pcr_parced)

      if pcr_parced["picup_id"]

        FromMailer.with(from_email: order.from_email, to_email: order.to_email, picupid: @picupid, orderno: order.id).fromtracking_email.deliver_later
        ToMailer.with(from_email: order.from_email, to_email: order.to_email, picupid: @picupid, orderno: order.id).totracking_email.deliver_later

      end

  end

  def send_tcreateresponse(newbody, order)

    envurl = ENV["PICUP_URL"]
    url = URI("https://#{envurl}/picup-api/v1/integration/create/courier-collection")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["api-key"] = ENV["PICUP_API_KEY"]
    request.body = newbody.to_json

    response = https.request(request)

    response.read_body
    puts response.read_body

      order.update(body: response.read_body)
      order.update(title: order.quotes.first.vehicle_id)
      # update processed status on succesful payment
      order.update(processed: true)

    puts "PICUP THIRD PARTY ORDER CREATED!!!!!!!!!"

    tcr_response = order.body
      
    tcr_parced = JSON.parse(tcr_response)
    JSON.pretty_generate(tcr_parced)

    if tcr_parced[0]

      SenderMailer.with(from_email: order.from_email, to_email: order.to_email, orderno: order.id).sender_email.deliver_later
      ReceiverMailer.with(from_email: order.from_email, to_email: order.to_email, orderno: order.id).receiver_email.deliver_later

    end

  end

  def clear_basket(value)

    # if value == true
    #   Basket.new
    # end
   

  end

  def new_basket


    session.delete(:basket_id)
  
 

  end

end # Class end
