#! /usr/bin/env fish

cd "$PWD/test"

source ../share/gem_home/gem_home.fish

function flunk
    echo "FAIL: $argv"
    exit 1
end

function test_gem_home_push
    set -l dir "$PWD/home/project1"
    set -l expected_gem_dir "$dir/.gem/$test_ruby_engine/$test_ruby_version"

    gem_home_push "$dir"

    [ "$expected_gem_dir" = "$GEM_HOME" ]; or flunk "did not set \$GEM_HOME correctly"
    [ "$expected_gem_dir" = (string split ':' "$GEM_PATH")[1] ]; or flunk "did not prepend to \$GEM_PATH"
    [ "$expected_gem_dir/bin" = "$PATH[1]" ]; or flunk "did not prepend the new gem bin/ dir to \$PATH"

    gem_home_pop
end

function test_gem_home_relative_path
    set -l dir "../test/home/project1"
    set -l expected_dir "$PWD/home/project1"
    set -l expected_gem_dir "$expected_dir/.gem/$test_ruby_engine/$test_ruby_version"

    gem_home_push "$dir"

    [ "$expected_gem_dir" = "$GEM_HOME" ]; or flunk "did not expand the relative gem dir"

    gem_home_pop
end

function test_gem_home_push_twice
    set -l dir1 "$PWD/home/project1"
    set -l expected_gem_dir1 "$dir1/.gem/$test_ruby_engine/$test_ruby_version"
    gem_home_push "$dir1"

    set -l dir2 "$PWD/home/project2"
    set -l expected_gem_dir2 "$dir2/.gem/$test_ruby_engine/$test_ruby_version"
    gem_home_push "$dir2"

    [ "$expected_gem_dir2" = "$GEM_HOME" ]; or flunk "did not set \$GEM_HOME to the second dir"
    [ "$expected_gem_dir2:$expected_gem_dir1" = (string join ':' (string split ':' "$GEM_PATH")[1..2]) ]; or flunk "did not prepend both gem dirs to \$GEM_PATH"
    [ "$expected_gem_dir2/bin $expected_gem_dir1/bin" = "$PATH[1..2]" ]; or flunk "did not inject the new gem bin/ into \$PATH"

    gem_home_pop
    gem_home_pop
end

function test_gem_home_pop
    set -l original_path "$PATH"
    set -l original_gem_path "$GEM_PATH"
    set -l original_gem_home "$GEM_HOME"

    gem_home_push "$PWD/home/project1"
    gem_home_pop

    [ "$original_path" = "$PATH" ]; or flunk "did not remove bin/ from \$PATH"
    [ "$original_gem_path" = "$GEM_PATH" ]; or flunk "did not remove gem dir from \$GEM_PATH"
    [ "$original_gem_home" = "$GEM_HOME" ]; or flunk "did not reset \$GEM_HOME"
end

function test_gem_home_pop_twice
    set -l original_path "$PATH"
    set -l original_gem_path "$GEM_PATH"
    set -l original_gem_home "$GEM_HOME"

    gem_home_push "$PWD/home/project1"
    gem_home_push "$PWD/home/project2"
    gem_home_pop
    gem_home_pop

    [ "$original_path" = "$PATH" ]; or flunk "did not remove bin/ from \$PATH"
    [ "$original_gem_path" = "$GEM_PATH" ]; or flunk "did not remove gem dir from \$GEM_PATH"
    [ "$original_gem_home" = "$GEM_HOME" ]; or flunk "did not reset \$GEM_HOME"
end

function setup
    mkdir -p "$PWD/home/project1" "$PWD/home/project2"
end

function teardown --on-process-exit %self
    rm -fr "$PWD/home"
end

setup

set test_ruby_engine (ruby -e "puts defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'")
set test_ruby_version (ruby -e "puts RUBY_VERSION")

functions | grep '^test_' | while read example
    eval $example
end

exit 0
