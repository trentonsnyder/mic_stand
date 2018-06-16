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

  scope :search,   -> (value) { where("LOWER(body) LIKE ?", "%#{value.downcase}%") }
  scope :ordering, -> (value) { sort_by_length(value) }

  def self.sort_by_length(value)
    if value == "long"
      order(Arel.sql("LENGTH(body) DESC"))
    elsif value == "short"
      order(Arel.sql("LENGTH(body) ASC"))
    end
  end

  def from_formatted
    from.phony_formatted(format: :international, spaces: "-")
  end
end
