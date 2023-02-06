# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Import do
  subject(:matcher_result) { matcher.matches?(klass) }

  let(:matcher) { described_class.new(method_name, **kwargs) }

  let(:method_name) { imported_method_name }
  let(:scope) { :class }
  let(:prepend) { false }

  let(:imported_method_name) { :"foo::bar::baz" }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {from: container, scope: scope, prepend: prepend} }

  let(:container) do
    Class.new do
      include ConvenientService::Support::DependencyContainer::Export

      export :"foo::bar::baz", scope: :class do
        ":foo::bar::baz with scope: :class"
      end

      export :foo do
        ":foo with scope: :instance"
      end
    end
  end

  let(:klass) do
    Class.new do
      include ConvenientService::Support::DependencyContainer::Import
    end
  end

  describe "#matches?" do
    before do
      klass.import(imported_method_name, **kwargs)
    end

    context "when method is NOT imported" do
      let(:method_name) { :non_existent }

      it "returns false" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when method is imported" do
      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end

    context "when scope is NOT passed" do
      let(:imported_method_name) { :foo }
      let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end

    context "when prepend is NOT passed" do
      let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:prepend]) }

      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("import `#{method_name}` with scope `#{scope}` from `#{container.class}` prepend: `#{prepend}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{klass.class}` to have imported `#{method_name}` with scope `#{scope}` from `#{container.class}` prepend: `#{prepend}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{klass.class}` NOT to have imported `#{method_name}` with scope `#{scope}` from `#{container.class}` prepend: `#{prepend}`")
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
