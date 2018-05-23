class Credit < ApplicationRecord
  belongs_to :user
  belongs_to :purchase, optional: true
  belongs_to :coupon, optional: true

  has_one :event

  validates :identifier,
    presence: true
  
  validate :coupon_or_purchase

  def register
    generate_identifier
    save
  end

  private

  def generate_identifier
    self.identifier = SecureRandom.uuid
  end

  def coupon_or_purchase
    if coupon_id == nil && purchase_id == nil
      errors.add(:base, "Must have coupon or purchase")
    elsif coupon_id != nil && purchase_id != nil
      errors.add(:base, "Cannot be claimed and purchased")
    end
  end
end