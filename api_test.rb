
require "uri"
require "net/http"
require 'json'

# GET Business Details


 

# puts("GET Business Details")

# url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/business-7c8350fa-0393-4c58-ba0c-3e547bf8834f/details")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Get.new(url)
# request["Content-Type"] = "application/json"
# request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"

# response = https.request(request)
# # puts response.read_body

# parsed_json = JSON.parse(response.read_body)

# whn =  parsed_json["warehouses"][0]["warehouse_name"]

# puts whn

# POST Quote One-to-Many

puts("POST Quote One-to-Many")

url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/quote/one-to-many")

https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/json"
request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"
request.body = "{\n    \"merchant_id\": \"merchant-d827f668-d434-4ce5-b853-878f874ae746\",\n    \"user_id\": \"\",\n    \"customer_ref\": \"Quote Example #2\",\n    \"is_for_contract_driver\": false,\n    \"scheduled_date\": \"2022-11-22T13:17:11.680476Z\",\n    \"courier_costing\": \"NONE\",\n    \"sender\": {\n        \"address\": {\n            \"unit_no\": null,\n            \"complex\": \"Picup Technologies\",\n            \"street_or_farm_no\": null,\n            \"street_or_farm\": \"6 Beach Road, Woodstock\",\n            \"suburb\": null,\n            \"city\": \"cape town\",\n            \"postal_code\": null,\n            \"country\": null,\n            \"latitude\": null,\n            \"longitude\": null\n        },\n        \"contact\": {\n            \"name\": \"Sender Contact Name\",\n            \"email\": \"quotetest@example.com\",\n            \"cellphone\": \"0211234567\"\n        },\n        \"special_instructions\": \"Use back door\"\n    },\n    \"receivers\": [\n        {\n            \"address\": {\n                \"unit_no\": null,\n                \"complex\": null,\n                \"street_or_farm_no\": null,\n                \"street_or_farm\": \"62 Greatmore St, Woodstock, Cape Town, 7915, South Africa\",\n                \"suburb\": null,\n                \"city\": \"cape town\",\n                \"postal_code\": null,\n                \"country\": null,\n                \"latitude\": null,\n                \"longitude\": null\n            },\n            \"contact\": {\n                \"name\": \"Test\",\n                \"email\": \"123@email.com\",\n                \"cellphone\": \"0211111234\"\n            },\n            \"special_instructions\": \"Mind the dog\",\n            \"parcels\": [\n                {\n                    \"size\": \"parcel-small\",\n                    \"reference\": \"quote-ref\",\n                    \"description\": \"parcel\",\n                    \"tracking_number\": null\n                }\n            ]\n        }\n    ],\n    \"optimize_waypoints\": true\n}"

response = https.request(request)
# puts response.read_body


parsed_json = JSON.parse(response.read_body)

price_incl_vat_motorcycle =  parsed_json["picup"]["service_types"][0]["price_incl_vat"]
price_incl_vat_car =  parsed_json["picup"]["service_types"][1]["price_incl_vat"]

distance_motorcycle =  parsed_json["picup"]["service_types"][0]["distance"]
distance_car =  parsed_json["picup"]["service_types"][1]["distance"]

duration_motorcycle =  parsed_json["picup"]["service_types"][0]["duration"]
duration_car =  parsed_json["picup"]["service_types"][1]["duration"]


puts "(Using Motorcycle) Price from Picup is: R" << String(price_incl_vat_motorcycle);
puts "(Using Motorcycle) Price from Haastig is (+30%): R" << String(price_incl_vat_motorcycle*1.3);
puts "Distance is: " << String(distance_motorcycle) << "km";
puts "Duration is: " << String(duration_motorcycle);
puts "";
puts "(Using Car) Price from Picup is: R" << String(price_incl_vat_car);
puts "(Using Car) Price from Haastig is (+30%): R" << String(price_incl_vat_car*1.3);
puts "Distance is: " << String(distance_car) << "km";
puts "Duration is: " << String(duration_car);




#  # POST Create One-to-Many

# puts("POST Create One-to-Many")

# url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/quote/one-to-many")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Post.new(url)
# request["Content-Type"] = "application/json"
# request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"
# request.body = "{\n    \"merchant_id\": \"merchant-d827f668-d434-4ce5-b853-878f874ae746\",\n    \"user_id\": \"\",\n    \"customer_ref\": \"Quote Example #2\",\n    \"is_for_contract_driver\": false,\n    \"scheduled_date\": \"2022-11-22T13:17:11.680476Z\",\n    \"courier_costing\": \"NONE\",\n    \"sender\": {\n        \"address\": {\n            \"unit_no\": null,\n            \"complex\": \"Picup Technologies\",\n            \"street_or_farm_no\": null,\n            \"street_or_farm\": \"6 Beach Road, Woodstock\",\n            \"suburb\": null,\n            \"city\": \"cape town\",\n            \"postal_code\": null,\n            \"country\": null,\n            \"latitude\": null,\n            \"longitude\": null\n        },\n        \"contact\": {\n            \"name\": \"Sender Contact Name\",\n            \"email\": \"quotetest@example.com\",\n            \"cellphone\": \"0211234567\"\n        },\n        \"special_instructions\": \"Use back door\"\n    },\n    \"receivers\": [\n        {\n            \"address\": {\n                \"unit_no\": null,\n                \"complex\": null,\n                \"street_or_farm_no\": null,\n                \"street_or_farm\": \"62 Greatmore St, Woodstock, Cape Town, 7915, South Africa\",\n                \"suburb\": null,\n                \"city\": \"cape town\",\n                \"postal_code\": null,\n                \"country\": null,\n                \"latitude\": null,\n                \"longitude\": null\n            },\n            \"contact\": {\n                \"name\": \"Test\",\n                \"email\": \"123@email.com\",\n                \"cellphone\": \"0211111234\"\n            },\n            \"special_instructions\": \"Mind the dog\",\n            \"parcels\": [\n                {\n                    \"size\": \"parcel-small\",\n                    \"reference\": \"quote-ref\",\n                    \"description\": \"parcel\",\n                    \"tracking_number\": null\n                }\n            ]\n        }\n    ],\n    \"optimize_waypoints\": true\n}"

# response = https.request(request)
# puts response.read_body

#  # POST Add to Bucket

#  puts("POST Add to Bucket")

# url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/add-to-bucket")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Post.new(url)
# request["Content-Type"] = "application/json"
# request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"
# request.body = "{\n  \"bucket_details\": {\n    \"delivery_date\": \"2020-06-10\",\n    \"shift_start\": \"09:00\",\n    \"shift_end\": \"17:00\",\n    \"warehouse_id\": \"warehouse-9cc07864-0255-4f84-b3f2-5697e21529e9\"\n  },\n  \"shipments\": [\n  \t{\n    \"consignment\": \"First Suburb\",\n    \"business_reference\": \"Order Number 7\",\n    \"address\": {\n    \t\"address_line1\": \"1\",\n    \t\"address_line2\": \"2\",\n    \t\"address_line3\": \"3\",\n    \t\"address_line4\": \"4\",\n      \"formatted_address\": \"62 Greatmore St, Woodstock, Cape Town, 7915, South Africa\",\n        \"latitude\": -33.9292364,\n        \"longitude\": 18.45457669999996,\n        \"street_or_farm_no\": \"62\",\n        \"street_or_farm\": \"Greatmore St\",\n        \"suburb\": \"Woodstock\",\n        \"city\": \"Cape Town\",\n        \"country\": \"South Africa\",\n        \"postal_code\": \"7915\"\n    },\n    \"contact\": {\n      \"customer_name\": \"Delivery Contact 1\",\n      \"customer_phone\": \"0821112223\",\n      \"email_address\": \"integrator@picup.co.za\",\n      \"special_instructions\": \"Special Instructions go here\"\n    },\n    \"parcels\": [\n      {\n        \"size\": \"parcel-small\",\n        \"tracking_number\": \"777-888-999\",\n        \"parcel_reference\": \"Parcel Number 1\",\n        \"description\": \"This is the first parcel\"\n      }\n     ]\n  \t}\n    ]\n  }\n"

# response = https.request(request)
# puts response.read_body

#  # GET Dispatch Summary

#  puts("GET Dispatch Summary")

# url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/business-7c8350fa-0393-4c58-ba0c-3e547bf8834f/dispatch-summary")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Get.new(url)
# request["Content-Type"] = "application/json"
# request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"

# response = https.request(request)
# puts response.read_body

#  # POST Stage-Order

#  puts("POST Stage-Order")

# url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/stage-order")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Post.new(url)
# request["Content-Type"] = "application/json"
# request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"
# request.body = "{\n  \"warehouse_id\": \"warehouse-9cc07864-0255-4f84-b3f2-5697e21529e9\",\n  \"shipments\": [\n    {\n      \"business_reference\": \"INV002.1\",\n      \"visit_type\": \"DELIVERY\",\n      \"address\": {\n        \"address\": \"Picup Technologies, 6 Beach Road, Woodstock, Cape Town, South Africa\",\n        \"latitude\": -28.632746799225856,\n        \"longitude\": 23.1591796875\n      },\n      \"contact\": {\n        \"customer_name\": \"customer\",\n        \"customer_phone\": \"phone\",\n        \"email_address\": \" email  \"\n      },\n      \"parcels\": [\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"INV001.1.1\"\n        }\n      ]\n    },\n    {\n      \"business_reference\": \"INV001.2\",\n      \"visit_type\": \"DELIVERY\",\n      \"address\": {\n        \"address\": \"Picup Technologies, 6 Beach Road, Woodstock, Cape Town, South Africa\",\n        \"latitude\": -21.432616864477335,\n        \"longitude\": 24.49951171875\n      },\n      \"contact\": {\n        \"customer_name\": \"customer\",\n        \"customer_phone\": \"phone\",\n        \"email_address\": \" email  \",\n        \"special_instructions\": \"Give to Mpho at Reception\",\n        \"delivery_window_start\": \"10:00\",\n        \"delivery_window_end\": \"12:00\"\n      },\n      \"parcels\": [\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"string\"\n        },\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"string\"\n        },\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"INV001.2.1\"\n        }\n      ]\n    },\n    {\n      \"business_reference\": \"INV001.3\",\n      \"visit_type\": \"DELIVERY\",\n      \"address\": {\n        \"address\": \"Picup Technologies, 6 Beach Road, Woodstock, Cape Town, South Africa\",\n        \"latitude\": -28.246327971048842,\n        \"longitude\": 34.25537109375\n      },\n      \"contact\": {\n        \"customer_name\": \"customer\",\n        \"customer_phone\": \"phone\",\n        \"email_address\": \" email  \",\n        \"special_instructions\": \"Give to Mpho at Reception\",\n        \"delivery_window_start\": \"10:00\",\n        \"delivery_window_end\": \"12:00\"\n      },\n      \"parcels\": [\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"INV001.3.1\"\n        },\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"string2\"\n        }\n      ]\n    },\n    {\n      \"business_reference\": \"INV001.4\",\n      \"visit_type\": \"DELIVERY\",\n      \"address\": {\n        \"address\": \"Picup Technologies, 6 Beach Road, Woodstock, Cape Town, South Africa\",\n        \"latitude\": -36.33282808737917,\n        \"longitude\": 23.752441406249996\n      },\n      \"contact\": {\n        \"customer_name\": \"customer\",\n        \"customer_phone\": \"phone\",\n        \"email_address\": \" email  \",\n        \"special_instructions\": \"Give to Mpho at Reception\",\n        \"delivery_window_start\": \"10:00\",\n        \"delivery_window_end\": \"12:00\"\n      },\n      \"parcels\": [\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"INV001.4.1\"\n        }\n      ]\n    },\n    {\n      \"business_reference\": \"INV001.5\",\n      \"visit_type\": \"DELIVERY\",\n      \"address\": {\n        \"address\": \"Picup Technologies, 6 Beach Road, Woodstock, Cape Town, South Africa\",\n        \"latitude\": -29.171348850951507,\n        \"longitude\": 14.78759765625\n      },\n      \"contact\": {\n        \"customer_name\": \"customer\",\n        \"customer_phone\": \"phone\",\n        \"email_address\": \" email  \",\n        \"special_instructions\": \"Give to Mpho at Reception\",\n        \"delivery_window_start\": \"10:00\",\n        \"delivery_window_end\": \"12:00\"\n      },\n      \"parcels\": [\n        {\n          \"size\": \"parcel-a4-envelope\",\n          \"parcel_reference\": \"INV001.5.1\"\n        }\n      ]\n    }\n  ]\n}"

# response = https.request(request)
# puts response.read_body

#  # POST Get Staged Orders

#  puts("POST Get Staged Orders")

# url = URI("https://otdcpt-knupqa.onthedot.co.za/picup-api//v1/integration/get-staged-orders")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Post.new(url)
# request["Content-Type"] = "application/json"
# request["api-key"] = "business-7c8350fa-0393-4c58-ba0c-3e547bf8834f"
# request.body = "{\n    \"from\": \"2019-12-01\",\n    \"to\": \"2020-12-30\"\n}"

# response = https.request(request)
# puts response.read_body