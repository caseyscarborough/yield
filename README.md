# Yield

Yield is a command line utility that generates a preview of README.md and markdown files using GitHub Flavored Markdown in your browser. It parses your markdown files using [GitHub's Markdown API](http://developer.github.com/v3/markdown/), so you can preview it exactly how it will look on GitHub.

## Installation

### Dependencies

* [Ruby v1.9.3](http://www.ruby-lang.org/en/) or greater
* [sinatra](http://sinatrarb.com)
* [thin](http://code.macournoyer.com/thin/)
* [launchy](https://github.com/copiousfreetime/launchy)

Install the gem by issuing the following command:

```bash
$ gem install yield
```

This will also install any necessary dependencies for the gem that are not currently installed.

## Usage

From the root of your project, or any folder containing a README.md file, run the following command:

```bash
$ yield
=* Yield is serving your markdown at http://localhost:4000/
```

You may also specify a path to a markdown file you'd like to render, such as:

```bash
$ yield UPDATES.md
```

Then navigate to [localhost:4000](http://localhost:4000) in your browser to view the preview of the file. You can stop the server by pressing Control+C.

## Issues

### API Rate Limit Exceeded

GitHub's API only allows only 60 unauthenticated requests per hour from a single IP address. If you are hitting this limit, then you must really like yield!

### OpenSSL Error

You may receive the following OpenSSL error after navigating to [localhost:4000](http://localhost:4000) on Mac OS X 10.8.

```
OpenSSL::SSL::SSLError at /
SSL_connect returned=1 errno=0 state=SSLv3 read server key exchange B: bad ecpoint
```

This error seems to be cause by a hosed installation of OpenSSL on the system. You can resolve this error by running the following commands:

```bash
$ brew install openssl
$ brew link openssl --force
$ rvm reinstall 2.0.0 --with-gcc=gcc
```

If this does not work for you, see the following links, which address the same issue:

* [How to install Ruby 2.0.0 with RVM on OSX 10.8 Mountain Lion](http://scottyv.me/2013/03/How-to-install-ruby-2-0-0-on-OSX-Mountain-Lion/)
* [“bad ecpoint” SSL error on fresh RVM Ruby 1.9.3 install on OSX Mountain Lion](http://stackoverflow.com/questions/15672133/bad-ecpoint-ssl-error-on-fresh-rvm-ruby-1-9-3-install-on-osx-mountain-lion)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
