class Message < ApplicationRecord
  belongs_to :event

  validates :body,
    presence: true,
    length: { minimum: 3, maximum: 333 }

  validates :from,
    presence: true,
    uniqueness: { scope: :event },
    length: { minimum: 7, maximum: 15 }

  def from_formatted
    from.phony_formatted(format: :international, spaces: '-')
  end
end
