# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware, type: :standard do
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
          intended_for :result, scope: any_scope, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::StubService
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call(*result_arguments.args, **result_arguments.kwargs, &result_arguments.block) }

        let(:method) { wrap_method(entity, :result, observe_middleware: middleware) }

        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware, scope) do |middleware, scope|
              include ConvenientService::Standard::Config

              middlewares :result, scope: scope do
                observe middleware
              end

              def result
                success
              end
            end
          end
        end

        context "when cache does NOT contain any stubs" do
          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .with_arguments(*result_arguments.args, **result_arguments.kwargs, &result_arguments.block)
              .and_return_its_value
          end

          it "returns original result" do
            expect(method_value).to be_success
          end
        end

        context "when cache contains one stub" do
          context "when that one stub with different arguments" do
            before do
              stub_service(service_class)
                .with_arguments(:bar, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)
            end

            it "returns original result" do
              expect(method_value).to be_success
            end
          end

          context "when that one stub with same arguments" do
            before do
              stub_service(service_class)
                .with_arguments(*args, **kwargs, &block)
                .to return_error
                .with_code(:same_arguments)
            end

            it "returns stub with same arguments" do
              expect(method_value).to be_error.with_code(:same_arguments)
            end
          end

          context "when that one stub with default (any arguments)" do
            before do
              stub_service(service_class)
                .to return_error
                .with_code(:with_default)
            end

            it "returns stub with default (any arguments)" do
              expect(method_value).to be_error.with_code(:with_default)
            end
          end

          context "when that one stub with any arguments" do
            before do
              stub_service(service_class)
                .to return_error
                .with_code(:with_any_arguments)
            end

            it "returns stub with any arguments" do
              expect(method_value).to be_error.with_code(:with_any_arguments)
            end
          end

          context "when that one stub without arguments" do
            before do
              stub_service(service_class)
                .without_arguments
                .to return_error
                .with_code(:without_arguments)
            end

            it "returns original result" do
              expect(method_value).to be_success
            end
          end
        end

        context "when cache contains multiple stubs" do
          context "when all of them with different arguments" do
            before do
              stub_service(service_class)
                .with_arguments(:bar, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)

              stub_service(service_class)
                .with_arguments(:baz, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)
            end

            it "returns original result" do
              expect(method_value).to be_success
            end
          end

          context "when one of them with different arguments and one with same arguments" do
            before do
              stub_service(service_class)
                .with_arguments(:bar, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)

              stub_service(service_class)
                .with_arguments(*args, **kwargs, &block)
                .to return_error
                .with_code(:same_arguments)
            end

            it "returns stub with same arguments" do
              expect(method_value).to be_error.with_code(:same_arguments)
            end
          end

          context "when one of them with different arguments and one with default (any arguments)" do
            before do
              stub_service(service_class)
                .with_arguments(:bar, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)

              stub_service(service_class)
                .to return_error
                .with_code(:with_default)
            end

            it "returns stub with any arguments" do
              expect(method_value).to be_error.with_code(:with_default)
            end
          end

          context "when one of them with different arguments and one with any arguments" do
            before do
              stub_service(service_class)
                .with_arguments(:bar, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)

              stub_service(service_class)
                .with_any_arguments
                .to return_error
                .with_code(:with_any_arguments)
            end

            it "returns stub with any arguments" do
              expect(method_value).to be_error.with_code(:with_any_arguments)
            end
          end

          context "when one of them with different arguments and one without arguments" do
            before do
              stub_service(service_class)
                .with_arguments(:bar, **kwargs, &block)
                .to return_error
                .with_code(:different_arguments)

              stub_service(service_class)
                .without_arguments
                .to return_error
                .with_code(:without_arguments)
            end

            it "returns original result" do
              expect(method_value).to be_success
            end
          end

          context "when one of them with same arguments and one with default (any arguments)" do
            before do
              stub_service(service_class)
                .with_arguments(*args, **kwargs, &block)
                .to return_error
                .with_code(:same_arguments)

              stub_service(service_class)
                .to return_error
                .with_code(:with_default)
            end

            it "returns stub same arguments" do
              expect(method_value).to be_error.with_code(:same_arguments)
            end
          end

          context "when one of them with same arguments and one with any arguments" do
            before do
              stub_service(service_class)
                .with_arguments(*args, **kwargs, &block)
                .to return_error
                .with_code(:same_arguments)

              stub_service(service_class)
                .with_any_arguments
                .to return_error
                .with_code(:with_any_arguments)
            end

            it "returns stub same arguments" do
              expect(method_value).to be_error.with_code(:same_arguments)
            end
          end

          context "when one of them with same arguments and one without arguments" do
            before do
              stub_service(service_class)
                .with_arguments(*args, **kwargs, &block)
                .to return_error
                .with_code(:same_arguments)

              stub_service(service_class)
                .without_arguments
                .to return_error
                .with_code(:without_arguments)
            end

            it "returns stub same arguments" do
              expect(method_value).to be_error.with_code(:same_arguments)
            end
          end
        end
      end
    end
  end

  context "when entity is service class" do
    it_behaves_like "verify middleware behavior" do
      let(:entity) { service_class }
      let(:scope) { :class }

      let(:result_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }
    end
  end

  context "when entity is service instance" do
    it_behaves_like "verify middleware behavior" do
      let(:entity) { service_instance }
      let(:scope) { :instance }

      let(:result_arguments) { ConvenientService::Support::Arguments.null_arguments }

      let(:service_instance) { service_class.new(*args, **kwargs, &block) }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
