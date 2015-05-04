module StripeWrapper
  class Customer
    attr_reader :response, :status, :token
    def initialize( options = {} )
      @response = options[:response]
      @status = options[:status]
      @token = options[:token]
    end
    def self.create( options={} )
      begin
      customer = Stripe::Customer.create(
        :source => options[:source],
        :plan => options[:plan] ,
        :email => options[:user].email
      )
      new(response: customer, status: :success, token: customer.id)
      rescue Stripe::InvalidRequestError, Stripe::CardError => e
        new(response: e, status: :error )
      end
    end
    def fail?
      status == :error
    end
    def error_message
      fail? ? response.message : nil
    end
    #def payment_method
    #  binding.pry
    #  (status == :success) ? response.object : nil
    #end
  end

  class Charge
    attr_reader :response, :status
    #def initialize(response, status)
    def initialize( options={} )
      @response = options[:response]
      @status = options[:status]
    end
    def self.set_api_key(key = nil)
      Stripe.api_key = ENV['stripe_api_key']
    end
    def self.create( options={} )
      #Charge.set_api_key
      #-->
      #set_api_key
      #-->
      #Refactory:
      #Move the code to the "config/initializers/stripe.rb"
      #so we don't need to call 'set_api_key' function
      #-->
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => options[:currency] || "usd",
          :source => options[:source],
          :description => options[:description] || ""
        )

        #Charge.new(response, :success)
        #new({response: response, status: :success})
        new( response: response, status: :success ) # named argument
      rescue Stripe::CardError => e
        #new(e, :error)
        #new({response: e, status: :error})
        new( response: e, status: :error)
      end
    end
    def fail?
      status == :error
    end
    def error_message
      fail? ? response.message : ""
    end
  end
end