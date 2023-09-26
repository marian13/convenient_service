# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:printer) { printer_class.new(matcher: matcher) }

  let(:printer_class) do
    Class.new(described_class) do
      def got_jsend_attributes_part
        ""
      end
    end
  end

  let(:matcher) { be_success }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { printer }

    it { is_expected.to have_attr_reader(:matcher) }
  end

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { printer }

      let(:printer) { described_class.new(matcher: matcher) }

      it { is_expected.to have_abstract_method(:got_jsend_attributes_part) }
    end

    describe "#result" do
      specify do
        expect { printer.result }
          .to delegate_to(printer.matcher, :result)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#chain" do
      specify do
        expect { printer.chain }
          .to delegate_to(printer.matcher, :chain)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#description" do
      it "returns description" do
        expect(printer.description).to eq(printer.expected_parts)
      end
    end

    describe "#failure_message" do
      it "returns message" do
        expect(printer.failure_message).to eq("expected result to be\n#{printer.expected_parts}\n\n#{printer.got_parts}")
      end
    end

    describe "#failure_message_when_negated" do
      it "returns message" do
        expect(printer.failure_message_when_negated).to eq("expected result NOT to be\n#{printer.expected_parts}\n\n#{printer.got_parts}")
      end
    end

    describe "#expected_parts" do
      specify do
        expect { printer.expected_parts }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedParts, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#got_parts" do
      specify do
        expect { printer.got_parts }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateGotParts, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#expected_code_part" do
      specify do
        expect { printer.expected_code_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedCodePart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#expected_data_part" do
      specify do
        expect { printer.expected_data_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedDataPart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#expected_message_part" do
      specify do
        expect { printer.expected_message_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedMessagePart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#expected_service_part" do
      specify do
        expect { printer.expected_service_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedServicePart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#expected_status_part" do
      specify do
        expect { printer.expected_status_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedStatusPart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#expected_step_part" do
      specify do
        expect { printer.expected_step_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedStepPart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#got_step_part" do
      specify do
        expect { printer.got_step_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateGotStepPart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    describe "#got_service_part" do
      specify do
        expect { printer.got_service_part }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateGotServicePart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(printer == other).to be_nil
          end
        end

        context "when `other` has different `matcher`" do
          let(:other) { printer_class.new(matcher: be_error) }

          it "returns `false`" do
            expect(printer == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { printer_class.new(matcher: matcher) }

          it "returns `true`" do
            expect(printer == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
