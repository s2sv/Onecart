class FromMailer < ApplicationMailer

    default from: 'info@haastig.com'

    def fromtracking_email
        @from_email = params[:from_email]
        @to_email = params[:to_email]
        @picupid = params[:picupid]
        @url  = "https://platform.picup.co.za/order-tracking?picupid={{#{@picupid}}}%20&waypointindex={{waypoint_index}}&contactindex=0"
        @haastig = "https://haastig.com/"
        @orderno =  params[:orderno]
        mail(to: @from_email, subject: 'Your tracking link!')
      end

end
