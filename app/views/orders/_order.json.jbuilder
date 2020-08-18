json.extract! order, :id, :title, :body, :from_address, :from_street_number, :from_locality, :from_route, :from_administrative_area_level_1, :from_country, :from_postal_code, :to_address, :to_street_number, :to_locality, :to_route, :to_administrative_area_level_1, :to_country, :to_postal_code, :user_id, :created_at, :updated_at
json.url order_url(order, format: :json)
