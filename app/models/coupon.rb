class Coupon < ApplicationRecord
  PARTS = 4
  has_many :credits

  validates :code,
    presence: true

  validates :worth,
    presence:     true,
    numericality: { greater_than: 0, less_than_or_equal_to: 10 }

  def self.claimed(user_id)
    Coupon.where("id IN (SELECT coupon_id
                          FROM credits 
                          WHERE purchase_id IS NULL 
                          AND user_id = ? 
                          GROUP BY coupon_id
                        )", user_id)
  end

  def self.unclaimed
    Coupon.where("id NOT IN (SELECT coupon_id 
                              FROM credits
                              WHERE purchase_id IS NULL
                              GROUP BY coupon_id)")
  end

  def generate_credits(user)
    self.worth.times do
      self.credits.new(user_id: user.id).register
    end
  end

  def register
    tap do |coupon|
      coupon.generate
      coupon.save
    end
  end

  def claimed?
    Credit.find_by(coupon_id: self.id)
  end

  def generate
    self.code = CouponCode.generate(parts: PARTS)
  end
end