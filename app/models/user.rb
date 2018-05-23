class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :purchases
  has_many :credits
  has_many :events

  validates :role,
    presence: true,
    inclusion: { in: %w(user admin) }
  
  def available_credits
    self.credits.where("credits.id NOT IN (SELECT credit_id FROM events WHERE user_id = ? AND id IS NOT NULL)", self.id)
  end

  def spent_credits
    self.credits.joins(:event)
  end
end
