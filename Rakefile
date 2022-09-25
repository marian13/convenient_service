# frozen_string_literal: true

require "bundler/gem_tasks"

##
# NOTE: Why not `bin' folder? It has a different purpose. It should contain "binaries/executables" that can be used by the end user.
# Search for `bin' in the following links for more info.
# - https://guides.rubygems.org/what-is-a-gem/
# - https://guides.rubygems.org/faqs/
#
task :confirm do
  require "tty-prompt"

  ##
  # NOTE: `ARGV[0]' contains `confirm' (this task name).
  #
  message = ARGV[1] || "Are you sure?"

  ##
  # NOTE: Why "tty-prompt"? No time to write, maintain complex, cross-platform bash scripts if you are an full-time application developer.
  #
  prompt = TTY::Prompt.new

  ##
  # NOTE: `prompt.yes?' docs.
  # https://github.com/piotrmurach/tty-prompt#25-yesno
  #
  yes = prompt.yes?(message)

  ##
  # NOTE: Use `echo $?' to debug exit code (0 means ok, 1 - error).
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
  # NOTE: Clears `ARGV' since both `rake' and `irb' uses it.
  # https://stackoverflow.com/a/2876645/12201472
  #
  ARGV.clear

  IRB.start(__FILE__)
end
