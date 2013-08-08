module Yield
  class Markdown < Sinatra::Base

    set :server, %w[thin]
    set :port, 4000
    @@content = nil
    @@filename = nil

    def self.init(filename = 'README.md')
      @@filename = filename.to_s
      original_stdout = $stdout
      $stdout = fake = StringIO.new
      unless File.exist?(@@filename)
        abort "Filename '#{@@filename}' doesn't exist."
      end
    end

    # Override run! method from Sinatra
    def self.run!(options = {})
      set options
      handler         = detect_rack_handler
      handler_name    = handler.name.gsub(/.*::/, '')
      server_settings = settings.respond_to?(:server_settings) ? settings.server_settings : {}
      handler.run self, server_settings.merge(:Port => port, :Host => bind) do |server|
        unless handler_name =~ /cgi/i
          $stderr.puts "=* Yield is serving your markdown at http://localhost:#{port}/"
        end
        [:INT, :TERM].each { |sig| trap(sig) { quit!(server, handler_name) } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
        # open_in_browser
        yield server if block_given?
      end
    rescue Errno::EADDRINUSE
      $stderr.puts "=* Port #{port} is already being used!"
    end

    # Override quit! method from Sinatra
    def self.quit!(server, handler_name)
      # Use Thin's hard #stop! if available, otherwise just #stop.
      server.respond_to?(:stop!) ? server.stop! : server.stop
      $stderr.puts "=* Stopping yield..." unless handler_name =~/cgi/i
    end

    get '/' do
      @@content = Octokit.markdown(File.read(@@filename), mode: 'gfm')
      erb :index, locals: { content: @@content, filename: @@filename }
    end

    not_found do
      erb :'404', locals: { filename: params[:filename] }
    end

    def self.open_in_browser
      Launchy.open("http://localhost:#{port}/")
    end
    
  end
end