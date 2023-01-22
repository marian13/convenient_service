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

  let(:full_name) { :foo }
  let(:scope) { :instance }
  let(:prepend) { false }

  let(:method) { container.exported_methods.find_by(full_name: full_name, scope: scope) }

  let(:import) { user.import(full_name, **kwargs) }
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

      context "when `mod` does NOT include `ConvenientService::Support::DependencyContainer::Export`" do
        let(:container) { Module.new }

        let(:error_message) do
          <<~TEXT
            Module `#{container}` can NOT export methods.

            Did you forget to include `ConvenientService::Container.export` into it?
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Errors::NotExportableModule`" do
          expect { import }
            .to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportableModule)
            .with_message(error_message)
        end
      end

      context "when `mod` includes `ConvenientService::Support::DependencyContainer::Export`" do
        context "when `method` is NOT exported" do
          let(:container) do
            Module.new do
              include ConvenientService::Support::DependencyContainer::Export
            end
          end

          let(:error_message) do
            <<~TEXT
              Module `#{container}` does NOT export method `#{full_name}` with `#{scope}` scope.

              Did you forget to export if from `#{container}`? For example:

              module #{container}
                export #{full_name}, scope: :#{scope} do |*args, **kwargs, &block|
                  # ...
                end
              end
            TEXT
          end

          it "raises `ConvenientService::Support::DependencyContainer::Errors::NotExportedMethod`" do
            expect { import }
              .to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportedMethod)
              .with_message(error_message)
          end
        end

        context "when `method` is exported" do
          let(:container) do
            Module.new do
              include ConvenientService::Support::DependencyContainer::Export

              export :foo do
                "foo"
              end
            end
          end

          specify do
            expect { import }
              .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::ImportMethod, :call)
              .with_arguments(importing_module: user, exported_method: method, prepend: prepend)
              .and_return_its_value
          end
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
