# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

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
            :success?,
            :failure?,
            :error?,
            :not_success?,
            :not_failure?,
            :not_error?
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

      let(:method) { wrap_method(result, :success?, observe_middleware: middleware) }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            self::Result.class_exec(middleware) do |middleware|
              middlewares :success? do
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

      specify do
        expect { method_value }
          .to delegate_to(result.internals.cache, :write)
          .with_arguments(:has_checked_status, true)
      end

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .and_return_its_value
      end
    end
  end
end
