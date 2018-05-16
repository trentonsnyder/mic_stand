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
end
