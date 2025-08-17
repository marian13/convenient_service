# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Commands::ResolveMethodsMiddlewaresCallers, type: :standard do
  let(:command_result) { described_class.call(container: container) }
  let(:command_instance) { described_class.new(container: container) }

  let(:container) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }
  let(:klass) { service_class }
  let(:service_class) { Class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { command_instance }

    it { is_expected.to have_attr_reader(:container) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { command }
  #
  #   it { is_expected.to delegate_method(:service_class).to(:container) }
  # end

  example_group "class methods" do
    describe ".call" do
      context "when own module `MethodsMiddlewaresCallers` is NOT defined" do
        it "defines own module `MethodsMiddlewaresCallers`" do
          expect { command_result }.to change { ConvenientService::Utils::Module.get_own_const(service_class, :MethodsMiddlewaresCallers) }
        end

        it "returns own module `MethodsMiddlewaresCallers`" do
          expect(command_result).to eq(service_class::MethodsMiddlewaresCallers)
        end
      end

      context "when own module `MethodsMiddlewaresCallers` is defined" do
        it "returns own module `MethodsMiddlewaresCallers`" do
          expect(command_result).to eq(service_class::MethodsMiddlewaresCallers)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
