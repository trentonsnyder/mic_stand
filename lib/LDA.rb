class LDA
  def initialize(sentences)
    # pass array of strings plz
    @sentences = sentences
    @tr        = GraphRank::Keywords.new
  end

  def process_top_words
    sanitized  = sanitize_sentences()
    paragraph  = sanitized.join(", ")
    text_body  = paragraph + " " + lost_words().join(", ")
    text_rank  = @tr.run(text_body)
    # run() returns array of arrays
    # maybe fork the gem and change to do sanatize and to_h in gem
    top_50    = text_rank[0..49]
    formatted  = top_50.to_h
    minus_lost = formatted.except(*lost_words())
  end

  private

  def sanitize_sentences
    # trying this out - find only unique words so that sentences like
    # "Buffalo buffalo, buffalo buffalo Buffalo buffalo" don't inflate word ranking
    @sentences.map { |s| s.downcase.gsub(/([.,;?:!()])|(#[a-zA-Z0-9]*)|(^|[^@\w])@(\w{1,15})/, "").chomp.split(" ").uniq }
  end

  def lost_words
    # add to make run() not fail with empty body
    ["occaecation", "papicolist", "plebicolar"]
  end
end
