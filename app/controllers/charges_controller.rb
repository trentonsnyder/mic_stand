class ChargesController < AuthorizedController
  def new
    @credit_count = current_user.available_credits.count
  end

  def create
    package = Offer.packages.detect { |p| p[:name] === params[:option] }
    if package
      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        customer:     customer.id,
        amount:       package[:amount],
        description:  "Credit purchase - #{package[:name]}",
        currency:     'usd'
      )
      current_user.purchases.create(worth: package[:worth])
    else
    Rails.logger.error("Package lookup failed.")
      flash[:error] = "Option unavailable."
      redirect_to new_charge_path
    end
  
  
  redirect_to new_charge_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end