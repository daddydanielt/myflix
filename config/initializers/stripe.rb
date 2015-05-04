Stripe.api_key = ENV['stripe_api_key']

StripeEvent.configure do |events|
  
  events.subscribe 'charge.failed' do |event|
    charge = event.data.object
    user = User.find_by(customer_token: charge.customer)
    user.deactivate!
  end

  events.subscribe 'charge.succeeded' do |event|
    # Define subscriber behavior based on the event object
    #event.class       #=> Stripe::Event
    #event.type        #=> "charge.failed"
    #event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
    #reference_id
    #@payment = Payment.new(user_id: user, ammount: ,reference_id: )
    charge = event.data.object
    user = User.find_by(customer_token: charge.customer)
    Payment.create(user: user, amount: charge.amount,reference_id: charge.id)
  end

  #events.all do |event|
  #  # Handle all event types - logging, etc.
  #end
  
end

#
#stripe_api_keyEvent.configure do
#  subscribe 'charge.succeeded' do |event|
#    #charge_info = event.data.object
#    #user = User.find_by(customer_token: charge_info.customer)
#    #Payment.create(user: user, amount: charge_info.amount, reference_id: charge_info.id)
#    Payment.create
#  end
#end