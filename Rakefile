# frozen_string_literal: true

require "bundler/gem_tasks"

##
# NOTE: Why not `bin` folder? It has a different purpose. It should contain "binaries/executables" that can be used by the end user.
# Search for `bin` in the following links for more info.
# - https://guides.rubygems.org/what-is-a-gem/
# - https://guides.rubygems.org/faqs/
#
task :confirm do
  require "tty-prompt"

  ##
  # NOTE: `ARGV[0]` contains `confirm` (this task name).
  #
  message = ARGV[1] || "Are you sure?"

  ##
  # NOTE: Why "tty-prompt"? No time to write, maintain complex, cross-platform bash scripts if you are a full-time application developer.
  #
  prompt = TTY::Prompt.new

  ##
  # NOTE: `prompt.yes?` docs.
  # https://github.com/piotrmurach/tty-prompt#25-yesno
  #
  yes = prompt.yes?(message)

  ##
  # NOTE: Use `echo $?` to debug exit code (0 means ok, 1 - error).
  #
  yes ? exit(0) : exit(1)
end

task :playground do
  require "irb"

  require_relative "env"

  require "convenient_service"

  require_relative "spec/support/convenient_service"
  require_relative "spec/support/convenient_service/rails" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].include?("rails")
  require_relative "spec/support/convenient_service/dry" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].include?("dry")

  ##
  # NOTE: Clears `ARGV` since both `rake` and `irb` uses it.
  # https://stackoverflow.com/a/2876645/12201472
  #
  ARGV.clear

  class SuccessService
    include ::ConvenientService::Standard::Config

    def result
      puts "run `SuccessService`"

      success
    end
  end

  class FailureService
    include ::ConvenientService::Standard::Config

    def result
      puts "run `FailureService`"

      failure
    end
  end

  class ErrorService
    include ::ConvenientService::Standard::Config

    def result
      puts "run `ErrorService`"

      error
    end
  end

  class ServiceWithSteps
    include ::ConvenientService::Standard::Config

    after :step do |step|
      puts "step #{step.printable_service} (index: #{step.index})"
    end

    step FailureService # 0 - run

    or_step :failure_method # 1 - run

    or_step SuccessService # 2 - run

    or_step FailureService # 3 - skip

    or_step SuccessService # 4 - skip

    step :success_method # 5 - run

    or_step FailureService # 6 - skip

    or_step FailureService # 7 - skip

    or_step SuccessService # 8 - skip

    step SuccessService # 9 - run

    step FailureService # 10 - run --- How to make higher precedence of `or`?

    or_step FailureService # 11 - run

    or_step :failure_method # 12 - run

    or_not_step FailureService # 13 - run

    or_step FailureService # 14 - skip

    or_step SuccessService # 15 - skip

    step :success_method # 16 - run

    not_step FailureService # 17 - run

    def success_method
      puts "run `success_method`"

      success
    end

    def failure_method
      puts "run `failure_method`"

      failure
    end

    def error_method
      puts "run `error_method`"

      error
    end
  end

  IRB.start(__FILE__)
end
