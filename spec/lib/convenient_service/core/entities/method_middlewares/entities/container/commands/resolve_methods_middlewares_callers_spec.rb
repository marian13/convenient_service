# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container::Commands::ResolveMethodsMiddlewaresCallers do
  let(:command_result) { described_class.call(scope: scope, container: container) }
  let(:command_instance) { described_class.new(scope: scope, container: container) }

  let(:scope) { :instance }
  let(:container) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(service_class: service_class) }
  let(:service_class) { Class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { command_instance }

    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:container) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegations" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { command }
  #
  #   it { is_expected.to delegate_method(:service_class).to(:container) }
  # end

  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::PrependModule

      context "when `scope` is `:instance`" do
        let(:scope) { :instance }

        context "when own module `InstanceMethodsMiddlewaresCallers` is NOT defined" do
          it "defines own module `InstanceMethodsMiddlewaresCallers`" do
            expect { command_result }.to change { ConvenientService::Utils::Module.get_own_const(service_class, :InstanceMethodsMiddlewaresCallers) }
          end

          it "returns own module `InstanceMethodsMiddlewaresCallers`" do
            expect(command_result).to eq(service_class::InstanceMethodsMiddlewaresCallers)
          end
        end

        context "when own module `InstanceMethodsMiddlewaresCallers` is defined" do
          it "returns own module `InstanceMethodsMiddlewaresCallers`" do
            expect(command_result).to eq(service_class::InstanceMethodsMiddlewaresCallers)
          end
        end
      end

      context "when `scope` is `:class`" do
        let(:scope) { :class }

        context "when own module `ClassMethodsMiddlewaresCallers` is NOT defined" do
          it "defines own module `ClassMethodsMiddlewaresCallers`" do
            expect { command_result }.to change { ConvenientService::Utils::Module.get_own_const(service_class, :ClassMethodsMiddlewaresCallers) }
          end

          it "returns own module `ClassMethodsMiddlewaresCallers`" do
            expect(command_result).to eq(service_class::ClassMethodsMiddlewaresCallers)
          end
        end

        context "when own module `ClassMethodsMiddlewaresCallers` is defined" do
          it "returns own module `ClassMethodsMiddlewaresCallers`" do
            expect(command_result).to eq(service_class::ClassMethodsMiddlewaresCallers)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
