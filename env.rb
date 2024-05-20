##
# NOTE: Appraisal sets `BUNDLE_GEMFILE` env variable.
# This is how appraisals can be differentiated from each other.
# https://github.com/thoughtbot/appraisal/blob/v2.4.1/lib/appraisal/command.rb#L36
#
# If `BUNDLE_GEMFILE` is an empty string, then `APPRAISAL_NAME` is resolved to an empty string as well.
# User passed `APPRAISAL_NAME` has a precedence.
#
# IMPORTANT: `APPRAISAL_NAME` env variable should be initialized as far as it is possible.
#
# IMPORTANT: ENV variables declared in this file should NOT be used inside the lib folder.
#
ENV["APPRAISAL_NAME"] ||= ENV["BUNDLE_GEMFILE"].to_s.then(&File.method(:basename)).then { |name| name.end_with?(".gemfile") ? name.delete_suffix(".gemfile") : "" }

puts "ENV[\"APPRAISAL_NAME\"] -> `#{ENV["APPRAISAL_NAME"]}`"

##
# NOTE: Ruby version may be set by docker.
# https://github.com/docker-library/ruby/blob/master/3.1/alpine3.16/Dockerfile#L30
#
ENV["RUBY_VERSION"] = ENV["RUBY_VERSION"].to_s[/\d+.\d+/] || ::RUBY_VERSION[/\d+.\d+/]

puts "ENV[\"RUBY_VERSION\"] -> `#{ENV["RUBY_VERSION"]}`"
