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

  # filters
  scope :funnel,   -> (value) { funnel_by_selected(value) }
  scope :ordering, -> (value) { ordering(value) }
  scope :search,   -> (value) { where("LOWER(body) LIKE ?", "%#{value.downcase}%") }

  def self.ordering(value)
    if value == "long"
      order(Arel.sql("LENGTH(body) DESC"))
    elsif value == "short"
      order(Arel.sql("LENGTH(body) ASC"))
    elsif value == "common"
      order("score DESC")
    elsif value == "unique"
      order("score ASC")
    end
  end

  def self.funnel_by_selected(value)
    if value == "selected"
      where("selected IS NOT NULL")
    elsif value == "unselected"
      where(selected: nil)
    end
  end

  def from_formatted
    from.phony_formatted(format: :international, spaces: "-")
  end

  def set_score
    score_ = 0
    sanitized_body = body.downcase.gsub(/[.,;?:!()]/, "").split(" ").uniq.join(", ")
    event.word_ranking.each { |w| score_ += w[1] if sanitized_body.include?(w[0]) }
    update_columns(score: score_)
  end

  def self.get_ranking
    LDA.new(find_each.map(&:body)).process_top_words()
  end
end
