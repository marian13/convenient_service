# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation::Middleware, type: :dry do
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

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::WrapMethod
        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call }

        let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware.with(status: status, skip_validations: skip_validations)) }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(status, skip_validations, middleware) do |status, skip_validations, middleware|
              include ConvenientService::Standard::Config.with({name: :dry_validation, enabled: true, status: status, skip_validations: skip_validations})

              middlewares :result do
                observe middleware.with(status: status, skip_validations: skip_validations)
              end

              contract do
                params do
                  required(:foo).value(:string, max_size?: 2)
                end
              end

              def result
                success
              end
            end
          end
        end

        let(:service_instance) { service_class.new }
        let(:skip_validations) { false }

        context "when contact does NOT have schema" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(status, skip_validations, middleware) do |status, skip_validations, middleware|
                include ConvenientService::Standard::Config.with({name: :dry_validation, enabled: true, status: status, skip_validations: skip_validations})

                middlewares :result do
                  observe middleware.with(status: status, skip_validations: skip_validations)
                end

                contract do
                  params do
                    required(:foo).value(:string, max_size?: 2)
                  end
                end

                def initialize(foo:)
                  @foo = foo
                end

                def result
                  success
                end
              end
            end
          end

          let(:service_instance) { service_class.new(foo: "x") }

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .and_return_its_value
          end
        end

        context "when `skip_validations` is `true`" do
          let(:skip_validations) { true }
          let(:service_instance) { service_class.new(foo: "bar") }

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .and_return_its_value
          end
        end

        context "when validation does NOT have any errors" do
          let(:service_instance) { service_class.new(foo: "x") }

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .and_return_its_value
          end
        end

        context "when validation has any error" do
          let(:service_instance) { service_class.new(foo: "bar") }

          let(:errors) { service_class.contract.new.call(**service_instance.constructor_arguments.kwargs).errors.to_h.transform_values(&:first) }

          it "returns result with first error message for each invalid attribute as data" do
            expect(method_value).to be_result(status).with_data(errors)
          end

          it "returns result with first error key/value joined by space as message" do
            expect(method_value).to be_result(status).with_message(errors.first.to_a.map(&:to_s).join(" "))
          end

          it "returns result with `:unsatisfied_dry_validation` as code" do
            expect(method_value).to be_result(status).with_code(:unsatisfied_dry_validation)
          end

          specify do
            expect { method_value }.not_to call_chain_next.on(method)
          end
        end
      end
    end
  end

  context "when status is NOT passed" do
    subject(:method_value) { method.call }

    include ConvenientService::RSpec::Helpers::WrapMethod

    let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(middleware) do |middleware|
          include ConvenientService::Standard::Config.with(:dry_validation)

          middlewares :result do
            observe middleware
          end

          contract do
            params do
              required(:foo).value(:string, max_size?: 2)
            end
          end

          def result
            success
          end
        end
      end
    end

    let(:service_instance) { service_class.new(foo: "bar") }

    it "defaults to `:error`" do
      expect(method_value).to be_error
    end
  end

  context "when status is failure" do
    it_behaves_like "verify middleware behavior" do
      let(:status) { :failure }
    end
  end

  context "when status is error" do
    it_behaves_like "verify middleware behavior" do
      let(:status) { :error }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
