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
    top_100    = text_rank[0..99]
    formatted  = top_100.to_h
    minus_lost = formatted.except(*lost_words())
  end

  private

  def sanitize_sentences
    # trying this out - find only unique words so that sentences like
    # "Buffalo buffalo, buffalo buffalo Buffalo buffalo" don't inflate word ranking
    @sentences.each { |s| s.downcase.gsub(/[.,;?:!()]/, "").split(" ").uniq }
  end

  def lost_words
    # add to make run() not fail with empty body
    ["occaecation", "papicolist", "plebicolar"]
  end
end
