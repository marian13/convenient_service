# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::ImportMethod do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::IncludeModule
      include ConvenientService::RSpec::Matchers::ExtendModule
      include ConvenientService::RSpec::Matchers::PrependModule
      include ConvenientService::RSpec::Matchers::SingletonPrependModule

      subject(:command_result) { described_class.call(importing_module: importing_module, exported_method: exported_method, prepend: prepend) }

      let(:importing_module) { ConvenientService::Support::DependencyContainer::Commands::CreateMethodsModule.call }

      let(:exported_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(full_name: full_name, scope: scope, body: body) }

      let(:full_name) { :"foo.bar.baz.qux" }
      let(:body) { proc { :"foo.bar.baz.qux" } }

      context "when `scope` is instance" do
        let(:scope) { :instance }

        context "when `prepend` is `false`" do
          let(:prepend) { false }

          it "includes `ImportedIncludedInstanceMethods` module to importing module" do
            command_result

            expect(importing_module).to include_module(importing_module::ImportedIncludedInstanceMethods)
          end

          specify do
            ##
            # NOTE: `command_result` is called to define `importing_module::ImportedIncludedInstanceMethods` before it is used by `delegate_to`.
            #
            command_result

            expect { command_result }
              .to delegate_to(exported_method, :define_in_module!)
              .with_arguments(importing_module::ImportedIncludedInstanceMethods)
              .and_return_its_value
          end

          example_group "`ImportedIncludedInstanceMethods` module" do
            it "is own" do
              command_result

              expect(importing_module.constants.map(&:to_s)).to include("ImportedIncludedInstanceMethods")
            end
          end
        end

        context "when `prepend` is `true`" do
          let(:prepend) { true }

          it "prepends `ImportedPrependedInstanceMethods` module to importing module" do
            command_result

            expect(importing_module).to prepend_module(importing_module::ImportedPrependedInstanceMethods)
          end

          specify do
            ##
            # NOTE: `command_result` is called to define `importing_module::ImportedPrependedInstanceMethods` before it is used by `delegate_to`.
            #
            command_result

            expect { command_result }
              .to delegate_to(exported_method, :define_in_module!)
              .with_arguments(importing_module::ImportedPrependedInstanceMethods)
              .and_return_its_value
          end

          example_group "`ImportedPrependedInstanceMethods` module" do
            ##
            # TODO: Create custom matcher.
            #
            it "is own" do
              command_result

              expect(importing_module.constants.map(&:to_s)).to include("ImportedPrependedInstanceMethods")
            end
          end
        end
      end

      context "when `scope` is class" do
        let(:scope) { :class }

        context "when `prepend` is `false`" do
          let(:prepend) { false }

          it "extends `ImportedIncludedClassMethods` module to importing module" do
            command_result

            expect(importing_module).to extend_module(importing_module::ImportedIncludedClassMethods)
          end

          specify do
            ##
            # NOTE: `command_result` is called to define `importing_module::ImportedIncludedClassMethods` before it is used by `delegate_to`.
            #
            command_result

            expect { command_result }
              .to delegate_to(exported_method, :define_in_module!)
              .with_arguments(importing_module::ImportedIncludedClassMethods)
              .and_return_its_value
          end

          example_group "`ImportedIncludedClassMethods` module" do
            it "is own" do
              command_result

              expect(importing_module.constants.map(&:to_s)).to include("ImportedIncludedClassMethods")
            end
          end
        end

        context "when `prepend` is `true`" do
          let(:prepend) { true }

          it "singleton prepends `ImportedPrependedClassMethods` module to importing module" do
            command_result

            expect(importing_module).to singleton_prepend_module(importing_module::ImportedPrependedClassMethods)
          end

          specify do
            ##
            # NOTE: `command_result` is called to define `importing_module::ImportedPrependedClassMethods` before it is used by `delegate_to`.
            #
            command_result

            expect { command_result }
              .to delegate_to(exported_method, :define_in_module!)
              .with_arguments(importing_module::ImportedPrependedClassMethods)
              .and_return_its_value
          end

          example_group "`ImportedPrependedClassMethods` module" do
            it "is own" do
              command_result

              expect(importing_module.constants.map(&:to_s)).to include("ImportedPrependedClassMethods")
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
