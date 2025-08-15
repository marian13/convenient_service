# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::ImportMethod, type: :standard do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::IncludeModule
      include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule
      include ConvenientService::RSpec::PrimitiveMatchers::PrependModule
      include ConvenientService::RSpec::PrimitiveMatchers::SingletonPrependModule

      subject(:command_result) { described_class.call(importing_module: importing_module, exported_method: exported_method, prepend: prepend) }

      let(:importing_module) { ConvenientService::Support::DependencyContainer::Commands::CreateMethodsModule.call }

      let(:exported_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: full_name, scope: scope, body: body) }

      let(:full_name) { :"foo.bar.baz.qux" }
      let(:body) { proc { :"foo.bar.baz.qux" } }

      let(:prepend) { false }

      ##
      # NOTE: This case is impossible in the read-world usage. Added this context for the coverage reasons.
      #
      context "when `scope` is nor `instance` neither `class`" do
        let(:scope) { :foo }

        let(:exception_message) do
          <<~TEXT
            Scope `#{scope.inspect}` is NOT valid.

            Valid options are `:instance`, `:class`.
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { command_result }.to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
      end

      context "when `scope` is `instance`" do
        let(:scope) { :instance }

        context "when `prepend` is `false`" do
          let(:prepend) { false }

          it "includes `ImportedIncludedInstanceMethods` module to importing module" do
            command_result

            expect(importing_module).to include_module(importing_module::ImportedIncludedInstanceMethods)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          it "delegates to `exported_method#define_in_module!`" do
            ##
            # NOTE: `described_class...` is called to define `importing_module::ImportedIncludedInstanceMethods` before it is used by `and_wrap_original`.
            #
            described_class.call(importing_module: importing_module, exported_method: exported_method, prepend: prepend)

            expect(exported_method)
              .to receive(:define_in_module!)
                .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[importing_module::ImportedIncludedInstanceMethods], {}, nil]) }

            command_result
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

          it "returns `exported_method#define_in_module!` value" do
            expect(command_result).to eq(exported_method.define_in_module!(importing_module::ImportedIncludedInstanceMethods))
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

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          it "delegates to `exported_method#define_in_module!`" do
            ##
            # NOTE: `described_class...` is called to define `importing_module::ImportedIncludedInstanceMethods` before it is used by `and_wrap_original`.
            #
            described_class.call(importing_module: importing_module, exported_method: exported_method, prepend: prepend)

            expect(exported_method)
              .to receive(:define_in_module!)
                .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[importing_module::ImportedPrependedInstanceMethods], {}, nil]) }

            command_result
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

          it "returns `exported_method#define_in_module!` value" do
            expect(command_result).to eq(exported_method.define_in_module!(importing_module::ImportedPrependedInstanceMethods))
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

      context "when `scope` is `class`" do
        let(:scope) { :class }

        context "when `prepend` is `false`" do
          let(:prepend) { false }

          it "extends `ImportedIncludedClassMethods` module to importing module" do
            command_result

            expect(importing_module).to extend_module(importing_module::ImportedIncludedClassMethods)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          it "delegates to `exported_method#define_in_module!`" do
            ##
            # NOTE: `described_class...` is called to define `importing_module::ImportedIncludedInstanceMethods` before it is used by `and_wrap_original`.
            #
            described_class.call(importing_module: importing_module, exported_method: exported_method, prepend: prepend)

            expect(exported_method)
              .to receive(:define_in_module!)
                .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[importing_module::ImportedIncludedClassMethods], {}, nil]) }

            command_result
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

          it "returns `exported_method#define_in_module!` value" do
            expect(command_result).to eq(exported_method.define_in_module!(importing_module::ImportedIncludedClassMethods))
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

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          it "delegates to `exported_method#define_in_module!`" do
            ##
            # NOTE: `described_class...` is called to define `importing_module::ImportedIncludedInstanceMethods` before it is used by `and_wrap_original`.
            #
            described_class.call(importing_module: importing_module, exported_method: exported_method, prepend: prepend)

            expect(exported_method)
              .to receive(:define_in_module!)
                .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[importing_module::ImportedPrependedClassMethods], {}, nil]) }

            command_result
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

          it "returns `exported_method#define_in_module!` value" do
            expect(command_result).to eq(exported_method.define_in_module!(importing_module::ImportedPrependedClassMethods))
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
