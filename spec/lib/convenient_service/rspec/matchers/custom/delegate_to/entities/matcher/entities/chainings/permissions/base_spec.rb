# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions::Base do
  let(:chaining) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher.new(object, method) }

  let(:klass) do
    Class.new do
      def foo
        bar
      end

      def bar
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { chaining }

    it { is_expected.to have_attr_reader(:matcher) }
  end

  example_group "instance methods" do
    describe "#allows?" do
      it "returns `false`" do
        expect(chaining.allows?).to eq(false)
      end
    end

    describe "#does_not_allow?" do
      it "returns opposite of `#allows?`" do
        expect(chaining.does_not_allow?).to eq(!chaining.allows?)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
