module ApplicationHelper
  class HTMLWithRouge < Redcarpet::Render::HTML
    def block_code(code, language)
      language ||= "text"
      formatter = Rouge::Formatters::HTML.new
      lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
      "<div class=\"highlight\"><pre class=\"highlight #{language}\"><code>#{formatter.format(lexer.lex(code))}</code></pre></div>"
    end
  end

  def markdown(text)
    return "" if text.blank?

    renderer = HTMLWithRouge.new(
      filter_html: false,
      link_attributes: { target: "_blank", rel: "noopener noreferrer" }
    )

    markdown = Redcarpet::Markdown.new(
      renderer,
      fenced_code_blocks: true,
      autolink: true,
      tables: true,
      strikethrough: true,
      superscript: true,
      space_after_headers: true,
      no_intra_emphasis: true
    )

    markdown.render(text).html_safe
  end

  def sanitize_url(url)
    return "#" if url.blank?

    uri = URI.parse(url)

    # Only allow http and https protocols
    if uri.scheme.nil? || %w[http https].include?(uri.scheme.downcase)
      url
    else
      "#"
    end
  rescue URI::InvalidURIError
    "#"
  end
end
