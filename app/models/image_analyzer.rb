class ImageAnalyzer

  attr_accessor :analyzed_text

  def initialize(paper)
    @paper = paper
  end
  attr_reader :paper

  def processed_variant
    paper.image.variant(:vision).processed
  end

  def analyze_image
    image = find_or_create_image_for_analysis
    api.call(prompt: paper.prompt, image: image)
  end

  def api
    @api ||= ChatAPI.new(:openai)
  end

  def find_or_create_image_for_analysis
    v = processed_variant
    data = v.download
    ChatAPI::Image.new(data: data, media_type: v.content_type)
  end

  def run
    return nil unless paper.initial?

    begin
      paper.update state: :processing
      j = nil
      try_count = nil
      begin
        error = true
        try_max = 3
        try_max.times do |i|
          try_count = i + 1
          j = analyze_image
          if j.system_error?
            sleep(0.5 * try_count) if try_count < try_max
          else
            error = false
            break
          end
        end
        raise "API error." if error
        self.analyzed_text = j.content
        paper.update analyzed_text: analyzed_text, state: :completed, raw_result: j,
                     num_try: try_count, analyzed_values: analyzed_values
      rescue => e
        paper.update error_reason: j, state: :error, raw_result: j,
                     num_try: try_count
      end
    rescue => e
      update error_reason: e, state: :error
    end
  end

  def analyzed_doc
    @analyzed_doc ||= Nokogiri::HTML(self.analyzed_text)
  end

  def analyzed_values
    doc = analyzed_doc
    list = doc.xpath('//paper').text.strip.split("\n").map do |line|
      line = line.strip
      if line =~ /^(.+?): (.+)$/
        key = $1; value = $2
        value = nil if value =~ /^\[.*\]$/
        value = nil if value == '不明'
        [key.to_sym, value]
      else
        nil
      end
    end.compact
    Hash[*list.flatten]
  end
end
