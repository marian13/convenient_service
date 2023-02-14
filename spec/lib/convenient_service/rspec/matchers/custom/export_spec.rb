# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Export do
  subject(:matcher_result) { matcher.matches?(container) }

  let(:matcher) { described_class.new(full_name, **kwargs) }

  let(:full_name) { :bar }
  let(:scope) { :class }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {scope: scope} }

  let(:container) do
    Class.new do
      include ConvenientService::Support::DependencyContainer::Export

      export :bar, scope: :class do
        ":bar with scope: :class"
      end

      export :foo do
        ":foo with scope: :instance"
      end
    end
  end

  describe "#matches?" do
    context "when method is NOT exported" do
      let(:full_name) { :non_existent }
      let(:scope) { :class }

      it "returns false" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when method is exported" do
      let(:full_name) { :bar }
      let(:scope) { :class }

      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end

    context "when scope is NOT passed" do
      let(:full_name) { :foo }
      let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("export `#{full_name}` with scope `#{scope}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{container.class}` to export `#{full_name}` with scope `#{scope}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{container.class}` NOT to export `#{full_name}` with scope `#{scope}`")
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
