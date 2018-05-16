class Coupon < ApplicationRecord

  PARTS = 4
  has_many :credits

  validates :code,
    presence: true
  
  validates :worth,
    presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  
  before_validation :generate

  def self.claim(user, code)
    validate = CouponCode.validate(code, PARTS)
    coupon = Coupon.find_by(code: validate)
    if coupon
      coupon.worth.times do
        coupon.credits.create(user_id: user.id)
      end
    end
  end

  def generate
    self.code = CouponCode.generate(parts: PARTS)
  end

end