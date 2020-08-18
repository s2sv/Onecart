class ReceiverMailer < ApplicationMailer
    default from: 'info@haastig.com'

    def receiver_email
        @from_email = params[:from_email]
        @to_email = params[:to_email]
        @haastig = "https://haastig.com/"
        @orderno =  params[:orderno]
        mail(to: @to_email, subject: 'Traditional Courier Order Placed!')
    end
    
end
