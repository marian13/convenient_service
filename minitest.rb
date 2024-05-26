##
# A custom runner for minitest.
# It is created to have a "simpler" interface than original rake task provides.
# - https://stackoverflow.com/questions/4788288/how-to-run-all-tests-with-minitest
##

##
# Takes the current working directory.
# - https://ruby-doc.org/core-2.7.0/Dir.html#method-c-pwd
#
current_dir = ::Dir.pwd

##
# Adds `test` to the load path in order to allow writing simply `require "test_helper"` in test files.
# - https://thoughtbot.com/blog/following-the-path
#
# NOTE: `unless` for idempotence.
#
$LOAD_PATH.unshift("#{current_dir}/test") unless $LOAD_PATH.include?("#{current_dir}/test")

##
# Recursively selects all `*_test.rb` files from the `test` folder or takes files passed in `ARGV` (files that do NOT end with `_test.rb` are filtered out).
# - https://lofic.github.io/tips/ruby-recursive_globbing.html
#
# Prepends `current_dir` to all files that are passed withoout a leading slash.
#
# TODO: Do not run `_test.rb` from vendor.
#
files =
  if ::ARGV.empty?
    ::Dir.glob("#{current_dir}/test/**/*_test.rb")
  else
    ::ARGV.to_a
      .map { |file| file.start_with?("/") ? file : "#{current_dir}/#{file}" }
      .select { |file| file.end_with?("_test.rb") }
  end

##
# Runs test files.
#
files.each { |file| require file }
