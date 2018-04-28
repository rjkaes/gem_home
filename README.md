# gem_home

Changes your `$GEM_HOME`.

# Inspiration

[postmodern gem_home for Bash and ZSH](https://github.com/postmodern/gem_home)

## Features

* Updates `$GEM_HOME`, `$GEM_PATH` and `$PATH`.
  * Switches `$GEM_HOME` by pushing and popping gem directories to `$GEM_PATH`.
    This allows the stacking of multiple gem directories.
  * Prepends the new `$GEM_HOME/bin` to `$PATH` so it takes precedence.
* Compartmentalizes gems into `.gem/$ruby_engine/$ruby_version`.
* Plays nicely with [RVM] and [chruby].
* Supports [fish].

## Synopsis

Change the `$GEM_HOME`:

    $ gem_home /path/to/project

Revert the `$GEM_HOME`:

    $ gem_home -

Using with bundler:

    $ cd padrino-app/
    $ gem_home .
    $ bundle install
    Fetching gem metadata from https://rubygems.org/.........
    Resolving dependencies...
    Using rake 10.3.2
    Using i18n 0.6.11
    Using json 1.8.1
    Using minitest 5.4.0
    Using thread_safe 0.3.4
    Installing tzinfo 1.2.2
    Using activesupport 4.1.4
    Using addressable 2.3.6
    Installing builder 3.2.2
    Using bundler 1.6.2
    Using data_objects 0.10.14
    Using dm-core 1.2.1
    Using dm-aggregates 1.2.0
    Using dm-do-adapter 1.2.0
    Using dm-migrations 1.2.0
    ...    
    $ padrino console # no `bundle exec` needed

* Notice how bundler re-used many of the gems from `~/.gem/...` but installed
  missing gems into `$PWD/.gem/...`.

## Configuration

Add the following to your `~/.config/fish/config.fish`:

```fish
source /usr/local/share/gem_home/gem_home.fish
```

## Alternatives

* [gs](https://github.com/inkel/gs#readme)
* [gst](https://github.com/tonchis/gst#readme)
* [ohmygems](http://blog.zenspider.com/blog/2012/09/ohmygems.html)
* [renv](https://github.com/fnichol/renv)

[RVM]: https://rvm.io/
[chruby]: https://github.com/postmodern/chruby#readme

[fish]: https://fishshell.com/
