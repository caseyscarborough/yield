require "sinatra"
require "octokit"
require_relative "yield/version"

module Yield

  class Markdown < Sinatra::Base

    @@content = nil
    @@filename = nil

    def self.render(filename = 'README.md')
      @@filename = filename
      begin
        @@content = Octokit.markdown(File.read(@@filename), mode: 'gfm')
      rescue Exception => e
        puts "Filename '#{@@filename}' doesn't exist."
        exit
      end
    end

    get '/' do
      erb :index, locals: { content: @@content, filename: @@filename }  
    end
  
  end

end
