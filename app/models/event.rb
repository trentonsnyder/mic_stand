class Event < ApplicationRecord
  belongs_to :user
  belongs_to :credit
  belongs_to :phone_number

  has_many :messages

  validates :name,
    presence: true,
    length:   { minimum: 1, maximum: 255 }

  validates :credit_id,
    uniqueness: true

  validates :session_expiry,
    presence: true

  validates :broadcast_token,
    presence: true

  # duration is length of event in seconds
  # 86400 = secs in a day
  validates :duration,
    presence:     true,
    numericality: { greater_than: 0, less_than_or_equal_to: 86_400 }

  def self.current
    where("session_expiry > ?", Time.current)
  end

  def self.duration_options
    # NOTE: <select> in simple_form format [label(hours), value(seconds)]
    [
      [1, 3_600],
      [2, 7_200],
      [3, 10_800],
      [4, 14_400],
      [5, 18_000],
    ]
  end

  def self.expired
    where("session_expiry < ?", Time.current)
  end

  def assign_broadcast_token
    self.broadcast_token = SecureRandom.urlsafe_base64(28)
  end

  def assign_credit
    credit = self.user.available_credits.first
    if credit
      self.credit_id = credit.id
    else
      errors.add(:credit, "Out of credits.")
    end
  end

  def assign_expiry
    if self.duration
      self.session_expiry = Time.zone.at(Time.current.to_i + self.duration).utc
    end
  end

  def assign_phone_number
    self.phone_number_id = PhoneNumber.find_available_id
  end

  def formatted_expiry
    session_expiry.strftime("%D %r")
  end

  def register
    tap do |event|
      event.assign_phone_number
      event.assign_credit
      event.assign_expiry
      event.assign_broadcast_token
      event.save!
    end
  end

  def time_left
    if self.session_expiry < Time.current
      "Expired"
    else
      Time.zone.at(self.session_expiry.to_i - Time.current.to_i).utc.strftime("%H:%M:%S")
    end
  end
end