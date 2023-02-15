# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Export do
  subject(:matcher_result) { matcher.matches?(container) }

  let(:matcher) { described_class.new(full_name, **kwargs) }

  let(:full_name) { :bar }
  let(:scope) { :class }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {scope: scope} }

  let(:container) do
    Module.new do
      include ConvenientService::DependencyContainer::Export

      export :bar, scope: :class do
        ":bar with scope: :class"
      end

      export :foo do
        ":foo with scope: :instance"
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::DependencyContainer::Import) }
    it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Constants) }
  end

  example_group "instance methods" do
    describe "#matches?" do
      context "when container can NOT export methods" do
        let(:container) { Module.new }

        let(:error_message) do
          <<~TEXT
            Module `#{container}` can NOT export methods.

            Did you forget to include `ConvenientService::DependencyContainer::Export` into it?
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Errors::NotExportableModule`" do
          expect { matcher_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportableModule)
            .with_message(error_message)
        end
      end

      context "when container can export methods" do
        it "does NOT raise" do
          expect { matcher_result }
            .not_to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportableModule)
        end
      end

      context "when scope is NOT passed" do
        let(:full_name) { :foo }
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

        it "defaults scope to :instance" do
          expect(matcher_result).to eq(true)
        end
      end

      context "when scope is passed, but NOT valid" do
        let(:full_name) { :foo }
        let(:scope) { :non_existent_scope }

        let(:error_message) do
          <<~TEXT
            Scope `#{scope.inspect}` is NOT valid.

            Valid options are `:instance`, `:class`.
          TEXT
        end

        it "raises `DependencyContainer::Errors::NotExportableModule`" do
          expect { matcher_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Errors::InvalidScope)
            .with_message(error_message)
        end
      end

      context "when scope is passed and valid" do
        let(:full_name) { :bar }
        let(:scope) { :class }

        it "does NOT raise" do
          expect { matcher_result }
            .not_to raise_error(ConvenientService::Support::DependencyContainer::Errors::InvalidScope)
        end
      end

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
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
