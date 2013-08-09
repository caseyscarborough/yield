module Yield
  class Server < Sinatra::Base

    set :server, 'webrick'

    # Override run! method from Sinatra
    def self.run!(port)
      settings = {}
      detect_rack_handler.run self, settings.merge(Port: port, Host: bind, Logger: WEBrick::Log.new('/dev/null'), AccessLog: []) do |server|
        $stderr.puts "=* Yield is serving your markdown at http://localhost:#{port}/"
        [:INT, :TERM].each { |sig| trap(sig) { quit!(server) } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
        open_in_browser(port)
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

    get '/:filename' do
      filename = params[:filename]
      if File.exist?(filename)
        content = Markdown.convert_to_html(File.read(filename))
        erb :index, locals: { content: content, filename: filename }
      else
        raise Sinatra::NotFound
      end
    end 

    not_found do 
      filename = request.fullpath.split('/')[-1]
      erb :'404', locals: { filename: filename }
    end

    def self.open_in_browser(port)
      Launchy.open("http://localhost:#{port}/")
    end

  end
end