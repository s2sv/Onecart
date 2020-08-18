class ApplicationController < ActionController::Base
  
before_action :set_cache_headers

include ApplicationHelper

def after_sign_in_path_for(resource)
  flash[:modal] = '#exampleModalLong'
    orders_path
  end




  


  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end

end
