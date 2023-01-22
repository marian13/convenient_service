# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Arguments::NullArguments do
  let(:null_arguments) { described_class.new }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Support::Arguments) }
  end

  example_group "instance methods" do
    describe "#args" do
      it "returns empty array" do
        expect(null_arguments.args).to eq([])
      end
    end

    describe "#kwargs" do
      it "returns empty hash" do
        expect(null_arguments.kwargs).to eq({})
      end
    end

    describe "#block" do
      it "returns `nil`" do
        expect(null_arguments.block).to be_nil
      end
    end

    describe "#null_arguments?" do
      it "returns `true`" do
        expect(null_arguments.null_arguments?).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
