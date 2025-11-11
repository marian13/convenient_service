# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasMethodReaders::Middleware, type: :standard do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :initialize, entity: :data
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
      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:method_value) { method.call(**kwargs) }

      let(:method) { wrap_method(data, :initialize, observe_middleware: middleware) }

      let(:kwargs) do
        {
          value: {foo: :foo, bar: :bar},
          result: result
        }
      end

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            self::Result::Data.class_exec(middleware) do |middleware|
              middlewares :initialize do
                observe middleware
              end
            end

            def result
              success
            end
          end
        end
      end

      let(:result) { service.result }
      let(:data) { result.unsafe_data }

      specify do
        expect { method_value }.to change(data, :singleton_methods).from([]).to([:foo, :bar])
      end

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      example_group "defined singleton method" do
        it "returns attribute value" do
          method_value

          expect([data.foo, data.bar]).to eq([:foo, :bar])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
