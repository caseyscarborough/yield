module Yield

  class BadConnection < StandardError; end

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
      $stderr.puts "=* Port #{port} is already in use."
    rescue Errno::EACCES
      $stderr.puts "=* Port #{port} could not be used: Permission denied."
    end

    # Override quit! method from Sinatra
    def self.quit!(server)
      server.stop
      $stderr.puts '=* Stopping yield...'
    end

    get '/' do
      begin
        filename = Markdown.filename
        content = Markdown.convert_to_html(File.read(filename))
        erb :index, locals: { content: content, filename: filename }
      rescue SocketError => e
        erb :error
      end
    end

    get '/:filename' do
      begin
        filename = params[:filename]
        content = Markdown.convert_to_html(File.read(filename))
        erb :index, locals: { content: content, filename: filename }
      rescue Errno::EISDIR
        raise Sinatra::NotFound
      rescue Errno::ENOENT
        raise Sinatra::NotFound
      rescue SocketError => e
        erb :error
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