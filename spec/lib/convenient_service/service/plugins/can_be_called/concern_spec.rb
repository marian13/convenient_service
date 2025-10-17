# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanBeCalled::Concern, type: :standard do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".call" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(foo: :bar, baz: :qux)
          end
        end
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { service_class.call(*args, **kwargs, &block) }
          .to delegate_to(service_class, :result)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:result).and_return(service_class.success(data: {bar: :foo, qux: :baz}))

        expect { service_class.call(*args, **kwargs, &block) }
          .to delegate_to(service_class.result(*args, **kwargs, &block), :call)
          .without_arguments
          .and_return_its_value
      end

      context "when result is stubbed" do
        before do
          stub_service(service_class).to return_failure
        end

        it "respects that result stub" do
          expect(service_class.call(*args, **kwargs, &block)).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(foo: :bar, baz: :qux)
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { service_instance.call }
          .to delegate_to(service_instance, :result)
          .without_arguments
      end

      specify do
        expect { service_instance.call }
          .to delegate_to(service_instance.result, :call)
          .without_arguments
          .and_return_its_value
      end

      context "when result is stubbed" do
        before do
          stub_service(service_class).to return_failure
        end

        it "respects that result stub" do
          expect(service_instance.call).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
