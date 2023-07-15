# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::SetsParentToForeignResult::Middleware do
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
          intended_for :result, entity: :service
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
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      let(:other_service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          def self.name
            "OtherService"
          end

          def result
            success
          end
        end
      end

      context "when result is NOT foreign" do
        context "when result is NOT from step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Configs::Standard

                middlewares :result do
                  observe middleware
                end

                def result
                  success
                end
              end
            end
          end

          it "returns result of service" do
            expect(method_value).to be_success.of_service(service_class)
          end

          it "returns result without step" do
            expect(method_value).to be_success.without_step
          end

          it "returns result without parents" do
            expect(method_value.parents).to eq([])
          end

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result is from step" do
          context "when result is from service step" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(other_service_class, middleware) do |other_service_class, middleware|
                  include ConvenientService::Configs::Standard

                  middlewares :result do
                    observe middleware
                  end

                  step other_service_class
                end
              end
            end

            it "returns result of service" do
              expect(method_value).to be_success.of_service(service_class)
            end

            it "returns result of service step" do
              expect(method_value).to be_success.of_step(other_service_class)
            end

            it "returns result with service step result as parent" do
              expect(method_value.parents).to eq([other_service_class.result])
            end

            specify do
              expect { method_value }
                .to call_chain_next.on(method)
                .without_arguments
                .and_return_its_value
            end
          end

          context "when result is from method step" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Configs::Standard

                  middlewares :result do
                    observe middleware
                  end

                  step :foo

                  def foo
                    success
                  end
                end
              end
            end

            it "returns result of service" do
              expect(method_value).to be_success.of_service(service_class)
            end

            it "returns result of method step" do
              expect(method_value).to be_success.of_step(:foo)
            end

            it "returns result with method step result as parent" do
              expect(method_value.parents).to eq([service_instance.foo])
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

      context "when result is foreign" do
        context "when result is NOT from step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(other_service_class, middleware) do |other_service_class, middleware|
                include ConvenientService::Configs::Standard

                middlewares :result do
                  observe middleware
                end

                define_method(:result) { other_service_class.result }
              end
            end
          end

          it "returns result of service" do
            expect(method_value).to be_success.of_service(service_class)
          end

          it "returns result without step" do
            expect(method_value).to be_success.without_step
          end

          it "returns result with foreign result as parent" do
            expect(method_value.parents).to eq([other_service_class.result])
          end

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .without_arguments
          end

          context "when result is from nested step" do
            let(:other_service_class) do
              Class.new do
                include ConvenientService::Configs::Standard

                step :foo

                def self.name
                  "OtherService"
                end

                def foo
                  success
                end
              end
            end

            it "returns result without step" do
              expect(method_value).to be_success.without_step
            end
          end
        end

        context "when result is from step" do
          context "when result is from method step" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(other_service_class, middleware) do |other_service_class, middleware|
                  include ConvenientService::Configs::Standard

                  middlewares :result do
                    observe middleware
                  end

                  step :foo

                  define_method(:foo) { other_service_class.result }
                end
              end
            end

            it "returns result of service" do
              expect(method_value).to be_success.of_service(service_class)
            end

            it "returns result of method step" do
              expect(method_value).to be_success.of_step(:foo)
            end

            it "returns result with foreign result as parent" do
              expect(method_value.parents).to eq([other_service_class.result])
            end

            specify do
              expect { method_value }
                .to call_chain_next.on(method)
                .without_arguments
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
