# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::NeverReachHere do
  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Exception) }
  end

  example_group "instance methods" do
    describe "#message" do
      let(:exception) { described_class.new(extra_message: extra_message) }
      let(:extra_message) { "foo" }

      let(:exception_message) do
        <<~TEXT
          The code that was supposed to be unreachable was executed.

          #{extra_message}
        TEXT
      end

      it "returns message concated with extra message passed to constructor" do
        expect(exception.message).to eq(exception_message)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
