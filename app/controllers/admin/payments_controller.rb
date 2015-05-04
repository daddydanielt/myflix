class Admin::PaymentsController < AdminedController
  def index
    #note: Just returning 'all' records is not always a good idea.
    @payments = Payment.all
  end
end