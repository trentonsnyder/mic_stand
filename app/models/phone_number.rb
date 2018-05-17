class PhoneNumber < ApplicationRecord
  # TODO: how can I support both US and Canada or international numbers?
  acts_as_paranoid

  has_many :events

  validates :phone_number,
    uniqueness: true,
    presence: true,
    length: { maximum: 12 }

  def phone_formatted
    phone_number.phony_formatted(format: :international, spaces: '-')
  end
end