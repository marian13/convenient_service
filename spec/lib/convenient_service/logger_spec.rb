# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Logger do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(Logger) }
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(Singleton) }
  end

  example_group "class methods" do
    describe ".new" do
      let(:logger) { described_class.new }

      before do
        allow(ENV).to receive(:[]).and_call_original
      end

      context "when `ENV[\"CONVENIENT_SERVICE_LOGGER_LEVEL\"]` is NOT passed" do
        before do
          allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_LOGGER_LEVEL").and_return(nil)
        end

        it "sets logger level to `Logger::INFO`" do
          logger

          expect(logger.level).to eq(Logger::INFO)
        end

        context "when `ENV[\"CONVENIENT_SERVICE_DEBUG\"]` is set to `\"true\"`" do
          before do
            allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_DEBUG").and_return("true")
          end

          it "sets logger level to `Logger::DEBUG` ignoring `ENV[\"CONVENIENT_SERVICE_LOGGER_LEVEL\"]` value" do
            logger

            expect(logger.level).to eq(Logger::DEBUG)
          end
        end
      end

      context "when `ENV[\"CONVENIENT_SERVICE_LOGGER_LEVEL\"]` is passed" do
        before do
          allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_LOGGER_LEVEL").and_return(Logger::WARN)
        end

        it "sets logger level to `ENV[\"CONVENIENT_SERVICE_LOGGER_LEVEL\"]`" do
          logger

          expect(logger.level).to eq(Logger::WARN)
        end

        context "when `ENV[\"CONVENIENT_SERVICE_DEBUG\"]` is set to `\"true\"`" do
          before do
            allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_DEBUG").and_return("true")
          end

          it "sets logger level to `Logger::DEBUG` ignoring `ENV[\"CONVENIENT_SERVICE_LOGGER_LEVEL\"]` value" do
            logger

            expect(logger.level).to eq(Logger::DEBUG)
          end
        end
      end

      context "when `ENV[\"CONVENIENT_SERVICE_LOGGER_ENABLE_COLORS\"]` is NOT set to `true`" do
        before do
          allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_LOGGER_ENABLE_COLORS").and_return(nil)
        end

        it "sets logger level to `Logger::INFO`" do
          logger

          expect(logger.formatter.class).to eq(described_class.original_formatter.class)
        end
      end

      context "when `ENV[\"CONVENIENT_SERVICE_LOGGER_ENABLE_COLORS\"]` is set to `true`" do
        before do
          allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_LOGGER_ENABLE_COLORS").and_return("true")
        end

        it "sets logger level to `ENV[\"CONVENIENT_SERVICE_LOGGER_LEVEL\"]`" do
          logger

          ##
          # TODO: Matcher to compare `Proc` instances.
          #
          expect(logger.formatter.source_location).to eq(described_class.colored_formatter.source_location)
        end
      end
    end

    describe ".original_formatter" do
      it "returns `Logger::Formatter.new`" do
        expect(described_class.original_formatter).to be_instance_of(Logger::Formatter)
      end
    end

    describe ".colored_formatter" do
      context "when `Paint` is NOT loaded" do
        before do
          allow(ConvenientService::Dependencies.paint).to receive(:loaded?).and_return(false)
        end

        it "returns `Logger::Formatter.new`" do
          expect(described_class.original_formatter).to be_instance_of(Logger::Formatter)
        end
      end

      context "when `Paint` is loaded" do
        before do
          allow(ConvenientService::Dependencies.paint).to receive(:loaded?).and_return(true)
        end

        it "returns colored formatter" do
          expect(described_class.colored_formatter).to be_instance_of(Proc)
        end

        example_group "colored formatter" do
          let(:colored_formatter) { described_class.colored_formatter }
          let(:original_formatter) { described_class.original_formatter }

          let(:colored_log) { colored_formatter.call(severity, datetime, progname, message) }
          let(:original_log) { original_formatter.call(severity, datetime, progname, message) }

          let(:datetime) { Time.now }
          let(:progname) { "Progname" }
          let(:message) { "Message" }

          context "when severity is NOT valid" do
            let(:severity) { :foo }

            it "returns original log" do
              expect(colored_log).to eq(original_log)
            end
          end

          context "when severity is valid" do
            context "when severity is `INFO`" do
              let(:severity) { "INFO" }

              it "returns colored log" do
                expect(colored_log).to eq(Paint[original_log, :cyan, :bold])
              end
            end

            context "when severity is `WARN`" do
              let(:severity) { "WARN" }

              it "returns colored log" do
                expect(colored_log).to eq(Paint[original_log, :yellow, :bold])
              end
            end

            context "when severity is `ERROR`" do
              let(:severity) { "ERROR" }

              it "returns colored log" do
                expect(colored_log).to eq(Paint[original_log, :red, :bold])
              end
            end

            context "when severity is `FATAL`" do
              let(:severity) { "FATAL" }

              it "returns colored log" do
                expect(colored_log).to eq(Paint[original_log, :red, :underline])
              end
            end

            context "when severity is `DEBUG`" do
              let(:severity) { "DEBUG" }

              it "returns colored log" do
                expect(colored_log).to eq(Paint[original_log, :magenta, :bold])
              end
            end

            context "when severity is `UNKNOWN`" do
              let(:severity) { "UNKNOWN" }

              it "returns colored log" do
                expect(colored_log).to eq(original_log)
              end
            end
          end
        end
      end
    end
  end

  example_group "instance methods" do
    let(:logger) { described_class.new }

    let(:integer_severity) { Logger::DEBUG }
    let(:string_severity) { "DEBUG" }

    context "when `severity` is NOT integer" do
      context "when `logger` does NOT support non integer levels" do
        let(:warning_message) do
          <<~MESSAGE
            `ConvenientService.logger.level` is reset from `#{string_severity}` to `Logger::INFO`.

            Stdlib `logger` with version `#{ConvenientService::Dependencies.logger.version}` does NOT support non-integer levels.
          MESSAGE
        end

        before do
          allow(ConvenientService::Dependencies).to receive(:support_logger_non_integer_levels?).and_return(false)

          ##
          # NOTE: Used to suppress printing.
          #
          allow(Warning).to receive(:warn)
        end

        it "fallbacks `level` to `Logger::INFO`" do
          logger.level = string_severity

          expect(logger.level).to eq(Logger::INFO)
        end

        it "prints warning" do
          ##
          # NOTE: `Kernel#warn` always calls `Warning.warn` under the hood.
          # - https://ruby-doc.org/core-2.7.0/Warning.html
          #
          expect { logger.level = string_severity }
            .to delegate_to(Warning, :warn)
            .with_arguments(warning_message)
            .without_calling_original
        end
      end

      context "when `logger` supports non integer levels" do
        before do
          allow(ConvenientService::Dependencies).to receive(:support_logger_non_integer_levels?).and_return(true)
        end

        it "sets `level` to corresponding integer severity" do
          logger.level = string_severity

          expect(logger.level).to eq(integer_severity)
        end
      end
    end

    context "when `severity` is integer" do
      before do
        logger.level = integer_severity
      end

      it "sets `level` to that integer" do
        expect(logger.level).to eq(integer_severity)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
