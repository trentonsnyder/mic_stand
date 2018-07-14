class ClaimCoupon
  include ActiveModel::Model
  # this merely exists to better pass back errors to coupon form
  
  attr_accessor :code

  validates :code,
    presence: true

  validate :parse

  PARTS = 4

  def claim(user)
    coupon = Coupon.unclaimed.find_by(code: self.code)
    if coupon
      coupon.generate_credits(user)
    else
      false
    end
  end

  def parse
    # swap out code for parsed code
    self.code = self.replace_chars
    if CouponCode.validate(self.code, 4).nil?
      errors.add(:code, "Invalid Code. Sorry :(")
    end
  end

  def replace_chars
    # CouponCode won't generate left hand values
    # but users could easily mistake these characters
    # maybe someday move this logic to front-end
    # https://github.com/grantm/Algorithm-CouponCode
    code.upcase()
        .gsub(/[OISZ]/,
          "O" => "0",
          "I" => "1",
          "S" => "5",
          "Z" => "2"
        )
  end

  def register(user)
    if valid?
      unless claim(user)
        errors.add(:code, "Sorry, couldn't find that one. Try again?")
        false
      else
        true
      end
    end
  end

end