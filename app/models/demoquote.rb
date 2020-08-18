class Demoquote 

  include ActiveModel::Model
  include ActiveModel::Attributes
 
  attribute :demoquote
  
  attribute :to_address
  
  attribute :from_address

  attribute :to_faddress
  attribute :from_faddress

  attribute :from_latitude
  attribute :from_longitude

  attribute :to_latitude
  attribute :to_longitude

  attribute :vehicle_id  

  attribute :from_complex
  attribute :to_complex
  
  
  attribute :product
  attribute :commit

end

