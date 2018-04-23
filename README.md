# GitShelf [![Build Status](https://travis-ci.org/mitsuru793/ruby-git-shelf.svg?branch=master)](https://travis-ci.org/mitsuru793/ruby-git-shelf) [![Maintainability](https://api.codeclimate.com/v1/badges/844dcdd519e1d7b83aab/maintainability)](https://codeclimate.com/github/mitsuru793/ruby-git-shelf/maintainability) [![Inline docs](http://inch-ci.org/github/mitsuru793/ruby-git-shelf.svg?branch=master)](http://inch-ci.org/github/mitsuru793/ruby-git-shelf)

GitShelf manages repositories cloned through it. If you clone repository with GitShelf, they are cached their data to a yaml and put each category directory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_shelf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_shelf

## Usage

```
$ bin/git-shelf
Commands:
  git-shelf count CATEGORY    # Count CATEGORY of repositories from cached yml. CATEGORY is listed on countable command.
  git-shelf countable         # List countable category of repositories from cached yml. You can use it on count command.
  git-shelf dump              # Dump repositories directory tree as a yaml.
  git-shelf get CATEGORY URL  # Get a repository from URL and put it into CATEGORY directory.
  git-shelf help [COMMAND]    # Describe available commands or one specific command
  git-shelf list [CATEGORY]   # list repository paths each category
```

### Clone repository

Clone into ruby category. You can create new category.

```shell
$ git-shelf ruby https://github.com/mitsuru793/ruby-git-shelf
$ tree ~/git-shelf
/Users/mitsuru793/git-shelf/ruby
└── github.com
    └── mitsuru793
        └── ruby-git-shelf
            ├── bin
            ...
```

### Count repositories each their data

Count the number of repositories only their data.

```shell
$ git-shelf count category
+------------+-------+
| Category   | Count |
+------------+-------+
| bash       | 1     |
| js         | 1     |
| javascript | 3     |
| dotfiles   | 6     |
| vim        | 10    |
| ruby       | 14    |
| php        | 64    |
+------------+-------+
```

### List repository paths

```shell
$ git-shelf list ruby
/Users/mitsuru793/ruby/github.com/YorickPeterse/oga
/Users/mitsuru793/ruby/github.com/carr/phone

$ git-shelf list ruby --no-base-path
ruby/github.com/YorickPeterse/oga
ruby/github.com/carr/phone
```
 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mitsuru793/ruby-git-shelf.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
