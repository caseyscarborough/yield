module Yield
  class Markdown < Sinatra::Base

    @content = nil
    @filename = nil

    def self.init(filename = 'README.md')
      @filename = filename.to_s
      $stdout = StringIO.new
      abort "Filename '#{@filename}' doesn't exist." unless File.exist?(@filename)
    end

    def self.convert_to_html(text)
      uri = URI('https://api.github.com/markdown')
      req = Net::HTTP::Post.new(uri.to_s)
      req.body = { text: "#{text}", mode: 'gfm' }.to_json
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
      response.body
    end

    def self.filename 
      @filename
    end

    def self.content
      @content
    end

  end
end