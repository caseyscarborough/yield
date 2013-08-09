module Yield
  class Server < Sinatra::Base

    set :server, 'webrick'
    set :port, 4000

    # Override run! method from Sinatra
    def self.run!()
      settings = {}
      detect_rack_handler.run self, settings.merge(Port: port, Host: bind, Logger: WEBrick::Log.new('/dev/null'), AccessLog: []) do |server|
        $stderr.puts "=* Yield is serving your markdown at http://localhost:#{port}/"
        [:INT, :TERM].each { |sig| trap(sig) { quit!(server) } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
        open_in_browser
        yield server if block_given?
      end
    rescue Errno::EADDRINUSE
      $stderr.puts "=* Port #{port} is already in use!"
    end

    # Override quit! method from Sinatra
    def self.quit!(server)
      server.stop
      $stderr.puts '=* Stopping yield...'
    end

    get '/' do
      filename = Markdown.filename
      content = Markdown.convert_to_html(File.read(filename))
      erb :index, locals: { content: content, filename: filename }
    end

    not_found { erb :'404' }

    def self.open_in_browser
      Launchy.open("http://localhost:#{port}/")
    end

  end
end