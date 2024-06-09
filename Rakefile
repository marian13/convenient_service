# frozen_string_literal: true

##
# NOTE: Why not `bin` folder? It has a different purpose. It should contain "binaries/executables" that can be used by the end user.
# Search for `bin` in the following links for more info.
# - https://guides.rubygems.org/what-is-a-gem/
# - https://guides.rubygems.org/faqs/
##

require "bundler/gem_tasks"

task :console do
  require "irb"

  require "convenient_service"

  require_relative "spec/support/convenient_service"
  require_relative "spec/support/convenient_service/standard"
  require_relative "spec/support/convenient_service/rails" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("rails")
  require_relative "spec/support/convenient_service/dry" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("dry")
  require_relative "spec/support/convenient_service/awesome_print" if ENV["APPRAISAL_NAME"] == "all" || ENV["APPRAISAL_NAME"].to_s.include?("awesome_print")
  require_relative "spec/support/convenient_service/amazing_print" if ENV["APPRAISAL_NAME"].to_s.include?("amazing_print")

  ##
  # NOTE: Clears `ARGV` since both `rake` and `irb` uses it.
  # https://stackoverflow.com/a/2876645/12201472
  #
  ARGV.clear

  IRB.start(__FILE__)
end
