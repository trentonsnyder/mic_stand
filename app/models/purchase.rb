class Purchase < ApplicationRecord
  belongs_to :user

  has_many :credits

  validates :worth,
    presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 1000 }

  after_create_commit :generate_credits

  private

  def generate_credits
    worth.times do
      credits.create(user_id: user_id)
    end
  end
end