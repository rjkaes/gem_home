function gem_home_push
    mkdir -p $argv ; and pushd $argv >/dev/null; or return 1

    set -l ruby_engine_and_version (ruby -e 'puts "#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'} #{RUBY_VERSION}"')
    set -l ruby_engine $ruby_engine_and_version[1]
    set -l ruby_version $ruby_engine_and_version[2]
    set -l gem_dir "$PWD/.gem/$ruby_engine/$ruby_version"

    test "$GEM_HOME" = "$gem_dir"; and return

    set -x GEM_HOME $gem_dir
    set -x GEM_PATH (string trim -r -c : $gem_dir:$GEM_PATH)
    set -qx PATH $gem_dir/bin $PATH

    popd >/dev/null
end

function gem_home_pop
    set -l gem_path (string split : $GEM_PATH)

    set -x PATH $PATH[2..-1]
    set -x GEM_HOME $gem_path[2]
    set -x GEM_PATH (string join : $gem_path[2..-1])
end

function gem_home_show
    test -z "$GEM_PATH"; and return

    for path in (string split : $GEM_PATH)
        if test "$path" = "$GEM_HOME"
            echo " * $path"
        else
            echo "   $path"
        end
    end
end

function gem_home
    set -l version "0.1.0"

    # Show the current GEM_HOME in use if no arguments are supplied.
    test (count $argv) -eq 0; and gem_home_show; and return

    switch $argv
        case -V --version
            echo "gem_home: $version"
        case -h --help
            echo "usage: gem_home [OPTIONS] [DIR|-]"
            echo
            echo "Options:"
            echo "    -V, --version Prints the version"
            echo "    -h, --help    Prints this message"
            echo
            echo "Arguments:"
            echo "    DIR Sets DIR as the new \$GEM_HOME"
            echo "    -   Reverts to the previous \$GEM_HOME"
            echo
            echo "Examples:"
            echo
            echo "  \$ gem_home path/to/project"
            echo "  \$ gem_home -"
            echo "  \$ gem_home --version"
            echo
        case -
            gem_home_pop
        case '*'
            gem_home_push $argv[1]
    end
end
