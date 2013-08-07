# Yield

Yield is a command line utility that generates a preview of README.md and markdown files using GitHub Flavored Markdown in your browser.

## Installation

### Dependencies

* Ruby
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
-> yield is now serving your markdown at localhost:4567 using Thin...
```

You may also specify a path to a markdown file you'd like to render, such as:

```bash
$ yield UPDATES.md
```

Then navigate to [localhost:4567](http://localhost:4567) in your browser to view the preview of the file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
