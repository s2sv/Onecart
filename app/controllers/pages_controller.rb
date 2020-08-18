class PagesController < ApplicationController
   before_action :set_margin
   before_action :set_contact
   after_action :set_modal
  #  before_action :demo_params


  layout "pages"

  # before_action :authenticate_user!

  def home
    @contact = Demoquote.new(demo_params)
  end

  def legal
  
  end



  def create
    
    @contact = Demoquote.new(demo_params)

    get_quoteresponse

    @quote_response = @response.read_body

    @parsed_json = JSON.parse(@response.read_body)
    @pretty_json = JSON.pretty_generate(@parsed_json)


    puts "THIS IS WERE WE ARE: #{@pretty_json}"

    @to = @parsed_json["request"]["receivers"][0]["address"]["complex"]
    @from = @parsed_json["request"]["sender"]["address"]["complex"]

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

              @choice = @parsed_json["request"]["receivers"][0]["parcels"][0]["reference"]

                  if @pbikequote = @parsed_json["picup"]["service_types"][0]["price_incl_vat"].present?

                    @roundpbq = @parsed_json["picup"]["service_types"][0]["price_incl_vat"]*@margin
                    @pbikequote = @roundpbq.round(2)
                    @pbikeduration = @parsed_json["picup"]["service_types"][0]["duration"]

                    @noqflag1 = false

                    else
                    
                    @noqflag1 = true

                  end

                  if @pcarquote = @parsed_json["picup"]["service_types"][1]["price_incl_vat"].present?

                    @roundpcq = @parsed_json["picup"]["service_types"][1]["price_incl_vat"]*@margin
                    @pcarquote = @roundpcq.round(2)
                    @pcarduration = @parsed_json["picup"]["service_types"][1]["duration"]

                    @noqflag2 = false

                    else
                    
                    @noqflag2 = true

                  end

                else     

                  @noqmessage = "Unfortunatly, our rabbits could not fetch you any on-demand quotes."
                  @why0 = "Here's why:"
                  @why1 = "The most likely reason is that an external partner's systems are down..."

            end

            if @parsed_json["third_party"]["valid"]

              @choice = @parsed_json["request"]["receivers"][0]["parcels"][0]["reference"]

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

              @why0 = "Here's why:"
              @why1 = "The most likely reason is that an external partner's systems are down...... Please contact support at info@haastig.com"

            end

    end

   


  end
 


  def new

   

    
    

  end

  def get_quoteresponse

    timestamp = Time.now + 5.minutes

    url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api/v1/integration/quote/one-to-many")
    

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["api-key"] = ENV["PICUP_QA_API_KEY"]
    request.body = request.body = "{\n    \"merchant_id\": \"merchant-d827f668-d434-4ce5-b853-878f874ae746\",\n    \"customer_ref\": \"Dummmy Quote\",\n    \"is_for_contract_driver\": false,\n    \"scheduled_date\": \"#{timestamp}\",\n    \"courier_costing\": \"ALL\",\n    \"sender\": {\n        \"address\": {\n            \"warehouse_id\": null,\n            \"unit_no\": null,\n            \"complex\": \"#{@contact.demoquote[:from_complex]}\",\n            \"street_or_farm_no\": null,\n            \"street_or_farm\": \"#{@contact.demoquote[:from_faddress]}, \",\n            \"suburb\": \"\",\n            \"city\": \"\",\n            \"postal_code\": \"\",\n            \"country\": \"South Africa\",\n            \"latitude\": #{@contact.demoquote[:from_latitude]},\n            \"longitude\": #{@contact.demoquote[:from_longitude]},\n            \"formatted_address\": \"#{@contact.demoquote[:from_faddress]}\"\n        },\n        \"contact\": {\n            \"name\": \"Greg\",\n            \"email\": \"greg@greg.com\",\n            \"cellphone\": \"0120131234\"\n        },\n        \"special_instructions\": \"\"\n    },\n    \"receivers\": [\n        {\n            \"address\": {\n                \"unit_no\": null,\n                \"complex\": \"#{@contact.demoquote[:to_complex]}\",\n                \"street_or_farm_no\": null,\n                \"street_or_farm\": \"#{@contact.demoquote[:to_faddress]}\",\n                \"suburb\": \"\",\n                \"city\": \"\",\n                \"postal_code\": \"\",\n                \"country\": \"South Africa\",\n                \"latitude\": #{@contact.demoquote[:to_latitude]},\n                \"longitude\": #{@contact.demoquote[:to_longitude]}\n            },\n            \"contact\": {\n                \"name\": \"James\",\n                \"email\": \"james@james.com\",\n                \"cellphone\": \"0121212345\"\n            },\n            \"special_instructions\": \"\",\n            \"parcels\": [\n                {\n                    \"size\": \"parcel-small\",\n                    \"reference\": \"#{@contact.demoquote[:vehicle_id]}\",\n                    \"tracking_number\": null\n                }\n            ]\n        }\n    ],\n    \"optimize_waypoints\": true\n}"
    # puts request.body
    # request.body = "{\n    \"merchant_id\": \"merchant-d827f668-d434-4ce5-b853-878f874ae746\",\n    \"customer_ref\": \"#{@contact.customer_ref}\",\n    \"is_for_contract_driver\": false,\n    \"scheduled_date\": \"#{timestamp}\",\n    \"courier_costing\": \"ALL\",\n    \"sender\": {\n        \"address\": {\n            \"warehouse_id\": null,\n            \"unit_no\": #{@contact.from_unit_no},\n            \"complex\": \"#{@contact.from_complex}\",\n            \"street_or_farm_no\": #{@contact.from_street_number},\n            \"street_or_farm\": \"#{@contact.from_route}, \",\n            \"suburb\": \"#{@contact.from_sublocality}\",\n            \"city\": \"#{@contact.from_locality}\",\n            \"postal_code\": \"#{@contact.from_postal_code}\",\n            \"country\": \"#{@contact.from_country}\",\n            \"latitude\": #{@contact.from_latitude},\n            \"longitude\": #{@contact.from_longitude},\n            \"formatted_address\": \"#{@contact.from_faddress}\"\n        },\n        \"contact\": {\n            \"name\": \"#{@contact.from_name}\",\n            \"email\": \"#{@contact.from_email}\",\n            \"cellphone\": \"#{@contact.from_phone}\"\n        },\n        \"special_instructions\": \"#{@contact.from_special_instructions}\"\n    },\n    \"receivers\": [\n        {\n            \"address\": {\n                \"unit_no\": #{@contact.to_unit_no},\n                \"complex\": \"#{@contact.to_complex}\",\n                \"street_or_farm_no\": #{@contact.to_street_number},\n                \"street_or_farm\": \"#{@contact.to_route}\",\n                \"suburb\": \"#{@contact.to_sublocality}\",\n                \"city\": \"#{@contact.to_locality}\",\n                \"postal_code\": \"#{@contact.to_postal_code}\",\n                \"country\": \"#{@contact.to_country}\",\n                \"latitude\": #{@contact.to_latitude},\n                \"longitude\": #{@contact.to_longitude}\n            },\n            \"contact\": {\n                \"name\": \"#{@contact.to_name}\",\n                \"email\": \"#{@contact.to_email}\",\n                \"cellphone\": \"#{@contact.to_phone}\"\n            },\n            \"special_instructions\": \"#{@contact.to_special_instructions}\",\n            \"parcels\": [\n                {\n                    \"size\": \"#{@contact.size}\",\n                    \"reference\": \"quote-ref\",\n                    \"tracking_number\": null\n                }\n            ]\n        }\n    ],\n    \"optimize_waypoints\": true\n}"
   

    @response = https.request(request)

    @response.read_body

   
  end

  def set_margin
    @margin = 1.3
  end

  def set_contact
  @contact = Demoquote.new(demo_params)
  end

  def set_modal
    flash[:modal] = ''
  end

  def demo_params
      params.permit(:product, :commit, demoquote:[:to_complex, :from_complex, :to_latitude, :to_longitude, :to_address, :from_address, :to_faddress, :from_faddress, :from_latitude, :from_longitude, :vehicle_id])
  end 

 


end
