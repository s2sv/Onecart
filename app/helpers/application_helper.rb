module ApplicationHelper
    def current_basket
    # Use Find by id to avoid potential errors
        if Basket.find_by_id(session[:basket_id]).nil?
            Basket.new
        else
            Basket.find_by_id(session[:basket_id])
        end

    end

    def button_to_with_icon(text, path, classes)
        form_tag path, :method => :get do
          button_tag(classes) do
            raw text
          end
        end
      end
end
