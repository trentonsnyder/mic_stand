class ClaimCouponsController < AuthorizedController
  def new
    @claim_coupon = ClaimCoupon.new()
  end

  def create
    @claim_coupon = ClaimCoupon.new(claim_coupon_params)
    if @claim_coupon.register(current_user)
      flash[:success] = "GOT EM"
      redirect_to new_event_path
    else
      render :new
    end
  end

  protected

  def claim_coupon_params
    params.require(:claim_coupon).permit(:code)
  end

end
