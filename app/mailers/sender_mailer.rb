class SenderMailer < ApplicationMailer
    default from: 'info@haastig.com'

    def sender_email
        @from_email = params[:from_email]
        @to_email = params[:to_email]
        @haastig = "https://haastig.com/"
        @orderno =  params[:orderno]
        mail(to: @from_email, subject: 'Traditional Courier Order Placed!')
    end
end
