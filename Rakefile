# frozen_string_literal: true

##
# NOTE: Why not `bin` folder? It has a different purpose. It should contain "binaries/executables" that can be used by the end user.
# Search for `bin` in the following links for more info.
# - https://guides.rubygems.org/what-is-a-gem/
# - https://guides.rubygems.org/faqs/
##

require "bundler/gem_tasks"

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
    # Starts console. `irb` is used by default.
    #
    def console
      irb
    end

    ##
    # Starts `irb`.
    # - https://github.com/ruby/irb
    #
    def irb
      require "irb"

      require "convenient_service"

      require_relative "spec/support/convenient_service"
      require_relative "spec/support/convenient_service/standard"
      require_relative "spec/support/convenient_service/rails" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("rails")
      require_relative "spec/support/convenient_service/dry" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("dry")
      require_relative "spec/support/convenient_service/awesome_print" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("awesome_print")
      require_relative "spec/support/convenient_service/amazing_print" if ENV["APPRAISAL_NAME"].to_s.include?("amazing_print")

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
    # Starts `pry`.
    # - https://github.com/pry/pry
    #
    def pry
      require "pry"

      require "convenient_service"

      require_relative "spec/support/convenient_service"
      require_relative "spec/support/convenient_service/standard"
      require_relative "spec/support/convenient_service/rails" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("rails")
      require_relative "spec/support/convenient_service/dry" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("dry")
      require_relative "spec/support/convenient_service/awesome_print" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("awesome_print")
      require_relative "spec/support/convenient_service/amazing_print" if ENV["APPRAISAL_NAME"].to_s.include?("amazing_print")

      ##
      # NOTE: `Pry.start` to start `pry` session is suggested by `bundle gem` command.
      # - https://bundler.io/v2.5/man/bundle-gem.1.html
      # - https://github.com/ruby/net-http/blob/v0.4.1/bin/console#L11
      #
      Pry.start
    end
  end
end
