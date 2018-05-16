class Credit < ApplicationRecord
  belongs_to :user
  belongs_to :purchase, optional: true
  belongs_to :coupon, optional: true

  validates :identifier,
    presence: true
  
  validate :coupon_or_purchase

  before_validation :generate_identifier

  private

  def generate_identifier
    self.identifier = SecureRandom.uuid
  end

  def coupon_or_purchase
    if coupon_id == nil && purchase_id == nil
      errors.add(:base, "Must have coupon or purchase")
    end
  end
end