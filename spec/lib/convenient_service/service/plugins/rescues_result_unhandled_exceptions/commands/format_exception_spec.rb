# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(exception: exception, args: args, kwargs: kwargs, block: block) }

      let(:exception) do
        service_class.result(*args, **kwargs, &block)
      rescue => error
        error
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      context "when exception has NO backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              ##
              # NOTE: Sometimes exceptions may have no backtrace, especially when they are created by developers manually, NOT by Ruby internals.
              #   - https://blog.kalina.tech/2019/04/exception-without-backtrace-in-ruby.html
              #   - https://github.com/jruby/jruby/issues/4467
              #
              # NOTE: Check the following tricky behaviour, it explains why an empty array is passed.
              #   `raise StandardError, "exception message", nil` ignores `nil` and still generates full backtrace.
              #   `raise StandardError, "exception message", []` generates no backtrace, but `exception.backtrace` returns `nil`.
              #
              raise StandardError, "exception message", []
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
          MESSAGE
        end

        it "returns formatted exception with full backtrace" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has backtrace with short backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "exception message", caller.take(10)
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.map { |line| "# #{line}" }.join("\n")}
          MESSAGE
        end

        it "returns formatted exception with full backtrace" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has backtrace with long backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "exception message", caller + ["# /line.rb:1:in `foo'"] * 10
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(10).map { |line| "# #{line}" }.join("\n")}
            # ...
          MESSAGE
        end

        it "returns formatted exception with trimmed backtrace" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has cause" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "cause message"
            rescue
              raise StandardError, "exception message"
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(10).map { |line| "# #{line}" }.join("\n")}
            # ...
            ------------------
            --- Caused by: ---
            #{exception.cause.class}:
              #{exception.cause.message}
            # #{exception.cause.backtrace.first}
          MESSAGE
        end

        it "returns formatted exception with cause" do
          expect(command_result).to eq(formatted_exception)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers