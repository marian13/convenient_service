# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Export, type: :standard do
  let(:container) do
    Module.new.tap do |mod|
      mod.module_exec(described_class) do |described_mod|
        include described_mod
      end
    end
  end

  let(:slug) { :foo }
  let(:scope) { :instance }

  let(:method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: slug, scope: scope, body: body) }

  let(:export) { container.export(slug, **kwargs, &body) }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {scope: scope} }
  let(:body) { proc { :bar } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "hook methods" do
    describe "#included" do
      context "when container is NOT `Module`" do
        let(:container) { Class.new }
        let(:include_module_result) { container.include described_class }

        let(:exception_message) do
          <<~TEXT
            `#{container.inspect}` is NOT a Module.
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Exceptions::NotModule`" do
          expect { include_module_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::NotModule)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { include_module_result }.to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::NotModule)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      end
    end
  end

  example_group "class methods" do
    describe "#export" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::DependencyContainer::Commands::AssertValidScope.call`" do
        expect(ConvenientService::Support::DependencyContainer::Commands::AssertValidScope)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {scope: scope}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        export
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns method" do
        expect(export).to eq(method)
      end

      it "adds method to exported methods" do
        expect { export }.to change { container.exported_methods.include?(method) }.from(false).to(true)
      end

      context "when `scope` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

        it "defaults to `ConvenientService::Support::DependencyContainer::Constants::DEFAULT_SCOPE`" do
          expect(export.scope).to eq(ConvenientService::Support::DependencyContainer::Constants::DEFAULT_SCOPE)
        end
      end
    end

    describe "#exported_methods" do
      let(:exported_methods) { ConvenientService::Support::DependencyContainer::Entities::MethodCollection.new }

      it "returns exported methods" do
        expect(container.exported_methods).to eq(exported_methods)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
