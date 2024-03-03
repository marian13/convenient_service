# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Error do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:printer) { described_class.new(matcher: be_error) }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base) }
  end

  example_group "instance methods" do
    describe "#got_jsend_attributes_part" do
      specify do
        expect { printer.got_jsend_attributes_part }
          .to delegate_to(described_class::Commands::GenerateGotJsendAttributesPart, :call)
          .with_arguments(printer: printer)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
