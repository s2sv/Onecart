class TimeWorker

    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(o_id)

        puts "SIDEKIQ WORKER SETTING QUOTE EXPIRE TIMER"

        @order = Order.find(o_id)

        if @order.processed == false

           
        

            @quote = @order.quotes.where(:order_id => o_id)
      
            @quote.destroy_by(:order_id => o_id)

        end
    end 

    

  

   

end