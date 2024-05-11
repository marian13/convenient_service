# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

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

      subject(:method_value) { method.call(**kwargs) }

      let(:method) { wrap_method(status, :success?, observe_middleware: middleware) }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Service::Configs::Standard

            self::Result.class_exec(middleware) do |middleware|
              self::Status.class_exec(middleware) do |middleware|
                middlewares :success? do
                  observe middleware
                end
              end
            end

            def result
              success
            end
          end
        end
      end

      let(:result) { service.result }
      let(:status) { result.status }

      context "when `mark_as_checked` option is NOT passed" do
        let(:kwargs) { {} }

        specify do
          expect { method_value }
            .to delegate_to(status.internals.cache, :write)
            .with_arguments(:checked, true)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when `mark_as_checked` option is `false`" do
        let(:kwargs) { {mark_as_checked: false} }

        specify do
          expect { method_value }
            .not_to delegate_to(status.internals.cache, :write)
            .with_any_arguments
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when `mark_as_checked` option is `true`" do
        let(:kwargs) { {mark_as_checked: true} }

        specify do
          expect { method_value }
            .to delegate_to(status.internals.cache, :write)
            .with_arguments(:checked, true)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .without_arguments
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
