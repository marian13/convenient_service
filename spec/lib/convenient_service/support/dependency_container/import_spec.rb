# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Import do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:user) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:container) do
    Module.new do
      include ConvenientService::Support::DependencyContainer::Export

      export :foo do
        "foo"
      end
    end
  end

  let(:slug) { :foo }
  let(:scope) { :instance }
  let(:prepend) { false }

  let(:method) { container.exported_methods.find_by(slug: slug, scope: scope) }

  let(:import) { user.import(slug, **kwargs) }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {from: container, scope: scope, prepend: prepend} }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "class methods" do
    describe "#import" do
      specify do
        expect { import }
          .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::AssertValidScope, :call)
          .with_arguments(scope: scope)
      end

      specify do
        expect { import }
          .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer, :call)
          .with_arguments(container: container)
      end

      specify do
        expect { import }
          .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::AssertValidMethod, :call)
          .with_arguments(slug: slug, scope: scope, container: container)
      end

      specify do
        expect { import }
          .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::ImportMethod, :call)
          .with_arguments(importing_module: user, exported_method: method, prepend: prepend)
          .and_return_its_value
      end

      context "when `as` is passed" do
        let(:kwargs) { default_kwargs.merge({as: alias_slug}) }
        let(:alias_slug) { :bar }
        let(:method_copy) { method.copy(overrides: {kwargs: {alias_slug: alias_slug}}) }

        it "imports method copy" do
          expect { import }
            .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::ImportMethod, :call)
            .with_arguments(importing_module: user, exported_method: method_copy, prepend: prepend)
            .and_return_its_value
        end
      end

      context "when `scope` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

        it "defaults to `ConvenientService::Support::DependencyContainer::Constants::DEFAULT_SCOPE`" do
          expect { import }
            .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::ImportMethod, :call)
            .with_arguments(importing_module: user, exported_method: method, prepend: prepend)
            .and_return_its_value
        end
      end

      context "when `prepend` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:prepend]) }

        it "defaults to `ConvenientService::Support::DependencyContainer::Constants::DEFAULT_PREPEND`" do
          expect { import }
            .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::ImportMethod, :call)
            .with_arguments(importing_module: user, exported_method: method, prepend: ConvenientService::Support::DependencyContainer::Constants::DEFAULT_PREPEND)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
