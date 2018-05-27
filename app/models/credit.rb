class Credit < ApplicationRecord
  belongs_to :user
  belongs_to :purchase, optional: true
  belongs_to :coupon, optional: true

  has_one :event

  validate :coupon_or_purchase

  def register
    tap do |credit|
      credit.save
    end
  end

  private

  def coupon_or_purchase
    if coupon_id == nil && purchase_id == nil
      errors.add(:base, "Must have coupon or purchase")
    elsif coupon_id != nil && purchase_id != nil
      errors.add(:base, "Cannot be claimed and purchased")
    end
  end
end
