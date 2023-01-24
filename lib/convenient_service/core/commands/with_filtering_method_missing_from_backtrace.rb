# frozen_string_literal: true

module ConvenientService
  module Core
    module Commands
      class WithFilteringMethodMissingFromBacktrace < Support::Command
        ##
        # @return [Regexp]
        #
        METHOD_MISSING_REGEXP = /lib\/convenient_service\/core\/(instance|class)_methods.rb/

        ##
        # @!attribute [r] block
        #
        attr_reader :block

        ##
        # @param block [Proc]
        # @return [void]
        #
        def initialize(&block)
          @block = block
        end

        ##
        # @return [Object] Can be any type.
        #
        def call
          block.call
        rescue => exception
          raise exception.class, exception.message, filter_backtrace(exception), cause: nil
        end

        private

        ##
        # @return [Array<String>]
        #
        # @note In order to test, place `abc` in `lib/convenient_service/examples/standard/gemfile/services/assert_file_not_empty.rb:18`. For example:
        #
        #   def result
        #     abc
        #
        #     return failure(data: {path: "Path is `nil`"}) if path.nil?
        #     return failure(data: {path: "Path is empty"}) if path.empty?
        #
        #     return error(message: "File with path `#{path}` is empty") if ::File.zero?(path)
        #
        #     success
        #   end
        #
        # @example Original backtrace:
        #
        #      NameError:
        #        undefined local variable or method `abc' for #<ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNot
        # Empty:0x0000558a152e4998>
        #      # ./lib/convenient_service/core/instance_methods.rb:44:in `block in method_missing'
        #      # ./lib/convenient_service/core/commands/with_backtrace_filtering.rb:27:in `call'
        #      # ./lib/convenient_service/support/command.rb:14:in `call'
        #      # ./lib/convenient_service/core/instance_methods.rb:44:in `method_missing'
        #      # ./lib/convenient_service/examples/standard/gemfile/services/assert_file_not_empty.rb:18:in `result'
        #      # ...
        #
        # @example Filtered backtrace:
        #
        #      NameError:
        #        undefined local variable or method `abc' for #<ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNot
        # Empty:0x000055fd2d8d9f70>
        #      # ./lib/convenient_service/examples/standard/gemfile/services/assert_file_not_empty.rb:18:in `result'
        #      # ...
        #
        def filter_backtrace(exception)
          exception.backtrace
            .drop_while { |line| line.match?(METHOD_MISSING_REGEXP) }
            .drop_while { |line| !line.match?(METHOD_MISSING_REGEXP) }
            .drop_while { |line| line.match?(METHOD_MISSING_REGEXP) }
        end
      end
    end
  end
end
