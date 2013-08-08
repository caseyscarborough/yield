# Yield

Yield is a command line utility that generates a preview of README.md and markdown files using GitHub Flavored Markdown in your browser. It parses your markdown files using [GitHub's Markdown API](http://developer.github.com/v3/markdown/), so you can preview it exactly how it will look on GitHub.

## Installation

### Dependencies

* [Ruby v2.0.0](http://www.ruby-lang.org/en/)
* [sinatra](http://sinatrarb.com)
* [thin](http://code.macournoyer.com/thin/)
* [octokit](http://octokit.github.io)

Install the gem by issuing the following command:

```bash
$ gem install yield
```

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

Then navigate to [localhost:4000](http://localhost:4000) in your browser to view the preview of the file.

You can stop the server by pressing Control+C.

### Errors

#### API Rate Limit Exceeded

GitHub's API only allows only 60 unauthenticated requests per hour from a single IP address. If you are hitting this limit, then you must really like yield!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
