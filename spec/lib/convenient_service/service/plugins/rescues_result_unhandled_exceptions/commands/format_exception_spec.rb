# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(exception: exception, args: args, kwargs: kwargs, block: block, max_backtrace_size: max_backtrace_size) }

      let(:exception) do
        service_class.result(*args, **kwargs, &block)
      rescue => error
        error
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      let(:max_backtrace_size) { 5 }

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            raise StandardError, "exception message"
          end
        end
      end

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatClass, :call)
          .with_arguments(klass: exception.class)
      end

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatMessage, :call)
          .with_arguments(message: exception.message)
      end

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatBacktrace, :call)
          .with_arguments(backtrace: exception.backtrace, max_size: max_backtrace_size)
      end

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatCause, :call)
          .with_arguments(cause: exception.cause)
      end

      context "when exception has NO backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

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

        it "returns formatted exception with no backtrace" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has backtrace with short backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception message", caller.take(5)
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
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception message", caller + ["# /line.rb:1:in `foo'"] * 5
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(5).map { |line| "# #{line}" }.join("\n")}
            # ...
          MESSAGE
        end

        it "returns formatted exception with trimmed backtrace" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has NO message" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, nil, caller
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.class}
            #{exception.backtrace.take(5).map { |line| "# #{line}" }.join("\n")}
            # ...
          MESSAGE
        end

        ##
        # NOTE: It is the default Ruby behavior to return the exception class as a message when the message is `nil`.
        #
        it "returns formatted exception with exception class as message" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has multiline message" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              message = <<~TEXT
                exception message first line
                exception message second line
                exception message second line
              TEXT

              raise StandardError, message, caller
            end
          end
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
            #{exception.message.split("\n").map { |line| "  #{line}" }.join("\n")}
            #{exception.backtrace.take(5).map { |line| "# #{line}" }.join("\n")}
            # ...
          MESSAGE
        end

        it "returns formatted exception with indentation for all message lines" do
          expect(command_result).to eq(formatted_exception)
        end
      end

      context "when exception has cause" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

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
            #{exception.backtrace.take(5).map { |line| "# #{line}" }.join("\n")}
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

      context "when `max_backtrace_size` is NOT passed" do
        subject(:command_result) { described_class.call(exception: exception, args: args, kwargs: kwargs, block: block) }

        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

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

        it "defaults to `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::DEFAULT_MAX_BACKTRACE_SIZE`" do
          expect(command_result).to eq(formatted_exception)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
