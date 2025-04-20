# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CachesConstructorArguments::Middleware, type: :standard do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :initialize, entity: any_entity
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_instance, :initialize, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :initialize do
              observe middleware
            end

            def initialize(*args, **kwargs, &block)
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **kwargs, &block) }

      it "writes `ConvenientService::Support::Arguments` instance to cache with `constructor_arguments` as key" do
        expect { method_value }
          .to delegate_to(service_instance.internals.cache, :write)
          .with_arguments(:constructor_arguments, ConvenientService::Support::Arguments.new(*args, **kwargs, &block))
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
