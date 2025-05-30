# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Export, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

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

        specify do
          expect { ignoring_exception(ConvenientService::Support::DependencyContainer::Exceptions::NotModule) { include_module_result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end
  end

  example_group "class methods" do
    describe "#export" do
      specify do
        expect { export }
          .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::AssertValidScope, :call)
          .with_arguments(scope: scope)
      end

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
