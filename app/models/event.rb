class Event < ApplicationRecord
  belongs_to :user
  belongs_to :credit
  belongs_to :phone_number

  has_many :messages

  validates :name,
    presence: true,
    length: { minimum: 1, maximum: 255 }

  validates :session_expiry,
    presence: true

  # duration is length of event in seconds
  # 86400 = secs in a day
  validates :duration,
    presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 86400 }

  def formatted_expiry
    session_expiry.strftime("%D %r")
  end

  def time_left
    if self.session_expiry < Time.current
      "Expired"
    else
      Time.zone.at(self.session_expiry.to_i - Time.current.to_i).utc.strftime("%H:%M:%S")
    end
  end
end