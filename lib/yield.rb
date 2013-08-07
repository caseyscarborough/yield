require "sinatra"
require "octokit"
require_relative "yield/version"

module Yield

  class Markdown < Sinatra::Base

    @@content = nil
    @@filename = nil

    def self.render(filename = 'README.md')
      @@filename = filename
      @@content = Octokit.markdown(File.read(@@filename), mode: 'gfm')
    end

    get '/' do
      erb :index, locals: { content: @@content, filename: @@filename }  
    end
  
  end

end
