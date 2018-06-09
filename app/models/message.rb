class Message < ApplicationRecord
  include Filterable
  paginates_per 25

  belongs_to :event

  validates :body,
    presence: true,
    length:   { minimum: 3, maximum: 333 }

  validates :from,
    presence:   true,
    uniqueness: { scope: :event },
    length:     { minimum: 7, maximum: 15 }

  scope :search,      -> (value) { where("LOWER(body) LIKE ?", "%#{value.downcase}%") }
  scope :body_length, -> (value) { sort_by_length(value) }

  def self.sort_by_length(value)
    if value == "long"
      order("LENGTH(body) DESC")
    elsif value == "short"
      order("LENGTH(body) ASC")
    end
  end

  def from_formatted
    from.phony_formatted(format: :international, spaces: "-")
  end
end
