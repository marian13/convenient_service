# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:klass) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:service) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.new(klass) }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "instance methods" do
    describe "#result" do
      let(:klass) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:service) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.new(klass) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { service.result(*args, **kwargs, &block) }
          .to delegate_to(klass, :result)
          .with_arguments(*args, **kwargs, &block)
          .and_return_its_value
      end
    end

    describe "#step_class" do
      specify do
        klass.commit_config!

        expect { service.step_class }
          .to delegate_to(klass, :step_class)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#lock" do
      specify do
        expect { service.lock }
          .to delegate_to(klass.__convenient_service_config__, :lock)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#has_defined_method?" do
      let(:method_name) { :foo }
      let(:method) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(method_name, direction: :input) }

      specify do
        expect { service.has_defined_method?(method) }
          .to delegate_to(ConvenientService::Utils::Method, :defined?)
          .with_arguments(method, klass, private: true)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` is NOT castable" do
          let(:other) { 42 }

          before do
            allow(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service).to receive(:cast).and_return(nil)
          end

          it "returns `nil`" do
            expect(service == other).to be_nil
          end
        end

        context "when `other` is castable" do
          context "when `other` has different klass" do
            let(:other) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.new(Class.new) }

            before do
              allow(described_class).to receive(:cast).and_call_original
            end

            it "returns `false`" do
              expect(service == other).to eq(false)
            end
          end

          context "when `other` has same attributes" do
            let(:other) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.new(klass) }

            before do
              allow(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service).to receive(:cast).and_call_original
            end

            it "returns `true`" do
              expect(service == other).to eq(true)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
