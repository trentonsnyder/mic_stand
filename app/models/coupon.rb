class Coupon < ApplicationRecord
  PARTS = 4
  has_many :credits

  validates :code,
    presence: true
  
  validates :worth,
    presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  
  def self.unclaimed
    Coupon.where("id NOT IN (SELECT coupon_id FROM credits WHERE purchase_id IS NULL GROUP BY coupon_id)")
  end
  
  def self.claim(user, code)
    validate = CouponCode.validate(code, PARTS)
    coupon = Coupon.find_by(code: validate)
    if coupon && !coupon.claimed?
      coupon.generate_credits(user)
    end
  end

  def generate_credits(user)
    self.worth.times do
      self.credits.new(user_id: user.id).register
    end
  end

  def register
    generate
    save
  end

  def claimed?
    Credit.find_by(coupon_id: self.id)
  end

  private

  def generate
    self.code = CouponCode.generate(parts: PARTS)
  end

end