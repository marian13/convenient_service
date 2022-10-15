# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container::Commands::PrependModule do
  let(:command_result) { described_class.call(scope: scope, container: container, mod: mod) }
  let(:command_instance) { described_class.new(scope: scope, container: container, mod: mod) }

  let(:scope) { :instance }
  let(:container) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(service_class: service_class) }
  let(:mod) { Module.new }
  let(:service_class) { Class.new }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { command_instance }

    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:container) }
    it { is_expected.to have_attr_reader(:mod) }
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

        it "prepend `mod` to `service_class`" do
          command_result

          expect(service_class).to prepend_module(mod)
        end
      end

      context "when `scope` is `:class`" do
        let(:scope) { :class }

        it "prepend `mod` to `service_class.singleton_class`" do
          command_result

          expect(service_class.singleton_class).to prepend_module(mod)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
