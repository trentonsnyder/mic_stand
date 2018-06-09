class PhoneNumber < ApplicationRecord
  # TODO: how can I support both US and Canada or international numbers?
  acts_as_paranoid

  has_many :events

  validates :phone_number,
    uniqueness: true,
    presence:   true,
    length:     { maximum: 12 }

  def self.find_available_id
    # can't pass NULL or "" into IN clause in postgres
    where("id NOT IN (?)", PhoneNumber.current_session_ids.presence || 0).first.try(:id)
  end

  def self.current_session_ids
    Event.where("session_expiry > ?", Time.current).map(&:phone_number_id)
  end

  def phone_formatted
    phone_number.phony_formatted(format: :international, spaces: "-").gsub(/\+1-/, "")
  end
end
