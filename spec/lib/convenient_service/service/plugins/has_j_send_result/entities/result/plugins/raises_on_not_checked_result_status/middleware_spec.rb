# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware do
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
          intended_for [
            :data,
            :message,
            :code
          ],
            entity: :result
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

      subject(:method_value) { method.call }

      let(:method) { wrap_method(result, method_name, observe_middleware: middleware) }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            self::Result.class_exec(middleware) do |middleware|
              middlewares :data do
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

      let(:method_name) { :data }

      context "when result does NOT have checked status" do
        before do
          result.internals.cache.delete(:has_checked_status)
        end

        let(:exception_message) do
          <<~TEXT
            Attribute `#{method_name}` is accessed before result status is checked.

            Did you forget to call `success?`, `failure?`, or `error?` on result?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Exceptions::StatusIsNotChecked`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Exceptions::StatusIsNotChecked)
            .with_message(exception_message)
        end
      end

      context "when result has checked status" do
        before do
          result.internals.cache.write(:has_checked_status, true)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
