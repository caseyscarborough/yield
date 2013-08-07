require "sinatra"
require "octokit"
require "thin"
require_relative "yield/version"


module Yield

  class Markdown < Sinatra::Base

    set :server, %w[thin]
    @@content = nil
    @@filename = nil

    # Override run! method from Sinatra
    def self.run!(options = {})
      set options
      handler         = detect_rack_handler
      handler_name    = handler.name.gsub(/.*::/, '')
      server_settings = settings.respond_to?(:server_settings) ? settings.server_settings : {}

      handler.run self, server_settings.merge(:Port => port, :Host => bind) do |server|
        unless handler_name =~ /cgi/i
          $stderr.puts "-> yield is now serving your markdown " +
          "at localhost:#{port} using #{handler_name}..."
        end
        [:INT, :TERM].each { |sig| trap(sig) { quit!(server, handler_name) } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
        yield server if block_given?
      end
    rescue Errno::EADDRINUSE
      $stderr.puts "-> Port #{port} is already being used!"
    end

    # Override quit! method from Sinatra
    def self.quit!(server, handler_name)
      # Use Thin's hard #stop! if available, otherwise just #stop.
      server.respond_to?(:stop!) ? server.stop! : server.stop
      $stderr.puts "\n-> Stopping yield..." unless handler_name =~/cgi/i
    end

    def self.render(filename = 'README.md')
      original_stdout = $stdout
      $stdout = fake = StringIO.new

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
