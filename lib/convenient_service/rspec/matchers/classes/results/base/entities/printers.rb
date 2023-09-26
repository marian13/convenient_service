# frozen_string_literal: true

require_relative "printers/base"
require_relative "printers/error"
require_relative "printers/failure"
require_relative "printers/null"
require_relative "printers/success"

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              module Printers
                class << self
                  ##
                  # @api private
                  #
                  # @param matcher [ConvenientService::RSpec::Matchers::Classes::Results::Base]
                  # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base]
                  #
                  def create(matcher:)
                    return Entities::Printers::Null.new(matcher: matcher) unless matcher.result

                    case matcher.result.status.to_sym
                    when :success
                      Entities::Printers::Success.new(matcher: matcher)
                    when :failure
                      Entities::Printers::Failure.new(matcher: matcher)
                    when :error
                      Entities::Printers::Error.new(matcher: matcher)
                    else
                      Entities::Printers::Null.new(matcher: matcher)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
