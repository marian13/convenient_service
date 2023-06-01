# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Import do
  include ConvenientService::RSpec::Matchers::DelegateTo

  subject(:matcher_result) { matcher.matches?(klass) }

  let(:matcher) { described_class.new(slug, **kwargs) }

  let(:slug) { imported_slug }
  let(:scope) { :class }
  let(:prepend) { false }
  let(:as) { "" }

  let(:imported_slug) { :"foo::bar::baz" }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {from: container, as: as, scope: scope, prepend: prepend} }

  let(:container) do
    Module.new do
      include ConvenientService::Support::DependencyContainer::Export

      export :"foo::bar::baz", scope: :class do
        ":foo::bar::baz with scope: :class"
      end

      export :que, scope: :class do
        ":que as: :xyzzy with scope: :class"
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

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::DependencyContainer::Import) }
  end

  describe "#matches?" do
    describe "container" do
      context "when `container` is valid" do
        before do
          klass.import(imported_slug, **kwargs)
        end

        specify do
          expect { matcher_result }
            .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer, :call)
            .with_arguments(container: container)
        end
      end

      context "when `container` is NOT valid" do
        let(:container) { Module.new }

        it "raises `ConvenientService::Support::DependencyContainer::Errors::NotExportableModule`" do
          expect { matcher_result }.to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportableModule)
        end
      end
    end

    describe "scope" do
      context "when scope is passed" do
        context "when `scope` is valid" do
          before do
            klass.import(imported_slug, **kwargs)
          end

          specify do
            expect { matcher_result }
              .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::AssertValidScope, :call)
              .with_arguments(scope: scope)
          end
        end

        context "when `scope` is NOT valid" do
          let(:scope) { nil }

          it "raises `ConvenientService::Support::DependencyContainer::Errors::InvalidScope`" do
            expect { matcher_result }.to raise_error(ConvenientService::Support::DependencyContainer::Errors::InvalidScope)
          end
        end
      end

      context "when `scope` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

        it "does NOT raise `ConvenientService::Support::DependencyContainer::Errors::InvalidScope`" do
          expect { matcher_result }.not_to raise_error(ConvenientService::Support::DependencyContainer::Errors::InvalidScope)
        end
      end
    end

    describe "namespace" do
      context "when `namespace` is present" do
        before do
          klass.import(imported_slug, **kwargs)
        end

        it "returns true" do
          expect(matcher_result).to be_truthy
        end
      end

      context "when `namespace` is NOT present" do
        it "returns false" do
          expect(matcher_result).to be_falsey
        end
      end
    end

    describe "prepend" do
      before do
        klass.import(imported_slug, **kwargs)
      end

      context "when `prepend` is passed" do
        it "returns true" do
          expect(matcher_result).to be_truthy
        end
      end

      context "when `prepend` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:prepend]) }

        it "returns true" do
          expect(matcher_result).to be_truthy
        end
      end
    end

    describe "as" do
      before do
        klass.import(imported_slug, **kwargs_with_as_modified)
      end

      let(:kwargs_with_as_modified) { {from: container, as: as, scope: scope, prepend: prepend} }

      let(:imported_slug) { :que }
      let(:as) { :xyzzy }

      context "when `as` is passed" do
        it "returns true" do
          expect(matcher_result).to be_truthy
        end
      end

      context "when `as` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:as]) }

        it "returns false" do
          expect(matcher_result).to be_falsey
        end
      end
    end

    describe "method" do
      before do
        klass.import(imported_slug, **kwargs)
      end

      let(:imported_slug) { :"foo::bar::baz" }

      context "when `method` is imported" do
        it "returns true" do
          expect(matcher_result).to be_truthy
        end
      end

      context "when `method` is NOT imported" do
        let(:slug) { :"non.existent.method" }

        it "returns false" do
          expect(matcher_result).to be_falsey
        end
      end
    end
  end

  describe "#description" do
    context "when `alias_slug` is present" do
      let(:as) { :"qux::quux" }

      it "returns message with `alias_slug`" do
        matcher_result

        expect(matcher.description).to eq("import `#{slug}` as: `#{as}` with scope: `#{scope}` from: `#{container}` with  prepend: `#{prepend}`")
      end
    end

    context "when `alias_slug` is NOT present" do
      it "returns message without `alias_slug`" do
        matcher_result

        expect(matcher.description).to eq("import `#{slug}` with scope: `#{scope}` from: `#{container}` with  prepend: `#{prepend}`")
      end
    end
  end

  describe "#failure_message" do
    context "when `alias_slug` is present" do
      let(:as) { :"qux::quux" }

      it "returns message with `alias_slug`" do
        matcher_result

        expect(matcher.failure_message).to eq("expected `#{klass}` to import `#{slug}` as: `#{as}` with scope: `#{scope}` from: `#{container}` with  prepend: `#{prepend}`")
      end
    end

    context "when `alias_slug` is NOT present" do
      it "returns message without `alias_slug`" do
        matcher_result

        expect(matcher.failure_message).to eq("expected `#{klass}` to import `#{slug}` with scope: `#{scope}` from: `#{container}` with  prepend: `#{prepend}`")
      end
    end
  end

  describe "#failure_message_when_negated" do
    context "when `alias_slug` is present" do
      let(:as) { :"qux::quux" }

      it "returns message with `alias_slug`" do
        matcher_result

        expect(matcher.failure_message_when_negated).to eq("expected `#{klass}` NOT to import `#{slug}` as: `#{as}` with scope: `#{scope}` from: `#{container}` with  prepend: `#{prepend}`")
      end
    end

    context "when `alias_slug` is NOT present" do
      it "returns message without `alias_slug`" do
        matcher_result

        expect(matcher.failure_message_when_negated).to eq("expected `#{klass}` NOT to import `#{slug}` with scope: `#{scope}` from: `#{container}` with  prepend: `#{prepend}`")
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
