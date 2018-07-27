class Message < ApplicationRecord
  include Filterable
  paginates_per 25

  belongs_to :event

  validates :body,
    presence: true,
    length:   { minimum: 5, maximum: 333 }
  
  validates :tweet_id,
    uniqueness: true

  validates :from,
    presence:   true,
    length:     { minimum: 3, maximum: 16 }

  validates :kind,
    presence:  true,
    inclusion: { in: ['sms', 'tweet'] }

  # filters
  scope :funnel,   -> (value) { funnel_by_selected(value) }
  scope :ordering, -> (value) { ordering(value) }
  scope :search,   -> (value) { where("LOWER(body) LIKE ?", "%#{value.downcase}%") }
  scope :kind,     -> (value) { where("kind = ?", "#{value.downcase}") }

  def self.ordering(value)
    if value == "long"
      order(Arel.sql("LENGTH(body) DESC"))
    elsif value == "short"
      order(Arel.sql("LENGTH(body) ASC"))
    elsif value == "common"
      order("score DESC")
    elsif value == "unique"
      order("score ASC")
    elsif value == "likes"
      order("likes DESC")
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
    sanitized_body = body.downcase.gsub(/([.,;?:!()])|(#[a-zA-Z0-9]*)|(^|[^@\w])@(\w{1,15})/, "").chomp.split(" ").uniq
    event.word_ranking.each { |k, v| score_ += v if sanitized_body.include?(k) }
    update_columns(score: score_)
  end

  def self.get_ranking
    LDA.new(find_each.map(&:body)).process_top_words()
  end
end
