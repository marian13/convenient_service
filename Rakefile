# frozen_string_literal: true

##
# NOTE: Why not `bin` folder? It has a different purpose. It should contain "binaries/executables" that can be used by the end user.
# Search for `bin` in the following links for more info.
# - https://guides.rubygems.org/what-is-a-gem/
# - https://guides.rubygems.org/faqs/
##

##
# Loads Bundler Rake tasks.
# - https://github.com/rubygems/rubygems/blob/master/bundler/lib/bundler/gem_tasks.rb
#
require "bundler/gem_tasks"

##
# Loads Convenient Service.
#
# @internal
#   NOTE:
#     There was an idea to lazily load Convenient Service + custom code for testing/debugging from rake tasks.
#     But it initially failed since it is NOT possible to define classes from methods using `class` keyword.
#     The second approach was to use `DATA` constant to get content after `__END__`, but it also failed since `DATA` constant does NOT exist when the script is NOT directly loaded by `ruby`. For example by `ruby file_name.rb`.
#     - https://www.fastruby.io/blog/exploring-global-constants-and-variables.html
#     - https://ruby-doc.org/core-2.7.2/doc/globals_rdoc.html
#
require "convenient_service"

require_relative "spec/support/convenient_service"
require_relative "spec/support/convenient_service/standard"
require_relative "spec/support/convenient_service/rails" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("rails")
require_relative "spec/support/convenient_service/dry" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("dry")
require_relative "spec/support/convenient_service/awesome_print" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("awesome_print")
require_relative "spec/support/convenient_service/amazing_print" if ENV["APPRAISAL_NAME"].to_s.include?("amazing_print")

task :console do
  RakeTasks.irb
end

task :irb do
  RakeTasks.irb
end

task :pry do
  RakeTasks.pry
end

##
# @internal
#   NOTE: If you need the task to behave as a method, how about using an actual method?
#   - https://stackoverflow.com/a/1290119/12201472
#
module RakeTasks
  class << self
    ##
    # Starts console session with loaded Convenient Service. `irb` is used by default.
    #
    # @return [void]
    # @see https://github.com/pry/pry
    #
    def console
      irb
    end

    ##
    # Starts `irb` session with loaded Convenient Service.
    #
    # @return [void]
    # @see https://github.com/ruby/irb
    #
    def irb
      require "irb"

      ##
      # NOTE: Clears `ARGV` since both `rake` and `irb` uses it. Uncomment if you would like to see the exception.
      # - https://stackoverflow.com/a/2876645/12201472
      #
      ARGV.clear

      ##
      # NOTE: `IRB.start(__FILE__)` to start `irb` session is suggested by `bundle gem` command.
      # - https://bundler.io/v2.5/man/bundle-gem.1.html
      # - https://github.com/ruby/net-http/blob/v0.4.1/bin/console#L14
      #
      IRB.start(__FILE__)
    end

    ##
    # Starts `pry` session with loaded Convenient Service.
    #
    # @return [void]
    # @see https://github.com/pry/pry
    #
    def pry
      require "pry"

      ##
      # NOTE: `Pry.start` to start `pry` session is suggested by `bundle gem` command.
      # - https://bundler.io/v2.5/man/bundle-gem.1.html
      # - https://github.com/ruby/net-http/blob/v0.4.1/bin/console#L11
      #
      Pry.start
    end
  end
end

##
# NOTE: Place and preload testing/debugging code after this comment...
##
