# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CollectsServicesInException::Middleware do
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
            :initialize,
            :result,
            :fallback_result
          ],
            entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::IgnoringException
      include ConvenientService::RSpec::Helpers::WrapMethod

      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      context "when method does NOT raise exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Service::Configs::Standard

              middlewares :result do
                observe middleware
              end

              def result
                success
              end
            end
          end
        end

        specify do
          expect { method_value }.to call_chain_next.on(method)
        end

        it "returns method value" do
          expect(method_value).to be_success.without_data
        end
      end

      context "when method raise exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(exception, middleware) do |exception, middleware|
              include ConvenientService::Service::Configs::Standard

              middlewares :result do
                observe middleware
              end

              def result
                raise exception
              end

              define_method(:exception) { exception }
            end
          end
        end

        let(:exception) { exception_class.new(exception_message) }
        let(:exception_class) { Class.new(StandardError) }
        let(:exception_message) { "exception message" }
        let(:service_details) { {instance: service_instance, trigger: {method: ":result"}} }

        context "when exception does NOT respond to `:services`" do
          let(:exception) { exception_class.new(exception_message) }

          it "defines `:services` singleton method on exception" do
            allow(service_instance).to receive(:exception).and_return(exception)

            expect { ignoring_exception(exception_class) { method_value } }.to change { exception.respond_to?(:services) }.from(false).to(true)
          end

          specify do
            allow(service_instance).to receive(:exception).and_return(exception)

            ##
            # NOTE: Called in order to define `services` method on exception.
            #
            ignoring_exception(exception_class) { method.call }

            expect { ignoring_exception(exception_class) { method.call } }
              .to delegate_to(ConvenientService::Utils::Array, :limited_push)
              .with_arguments(exception.services, service_details, limit: ConvenientService::Service::Plugins::CollectsServicesInException::Constants::DEFAULT_MAX_SERVICES_SIZE)
          end

          specify do
            allow(service_instance).to receive(:exception).and_return(exception)

            expect { ignoring_exception(exception_class) { method_value } }
              .to delegate_to(ConvenientService::Service::Plugins::CollectsServicesInException::Commands::ExtractServiceDetails, :call)
              .with_arguments(service: service_instance, method: :result)
          end

          example_group "defined `:services` method" do
            it "returns services" do
              ignoring_exception(exception_class) { method_value }

              expect(exception.services).to eq([service_details])
            end
          end

          it "reraises exception" do
            expect { method_value }
              .to raise_error(exception_class)
              .with_message(exception_message)
          end
        end

        context "when exception responds to `:services`" do
          let(:exception) do
            exception_class.new(exception_message).tap do |exception|
              exception.define_singleton_method(:services) { @services ||= [:original_service] }
            end
          end

          it "reuses existing `:services` singleton method on exception" do
            allow(service_instance).to receive(:exception).and_return(exception)

            ignoring_exception(exception_class) { method_value }

            expect(exception.services).to eq([:original_service, service_details])
          end

          specify do
            allow(service_instance).to receive(:exception).and_return(exception)

            expect { ignoring_exception(exception_class) { method_value } }
              .to delegate_to(ConvenientService::Service::Plugins::CollectsServicesInException::Commands::ExtractServiceDetails, :call)
              .with_arguments(service: service_instance, method: :result)
          end

          specify do
            allow(service_instance).to receive(:exception).and_return(exception)

            expect { ignoring_exception(exception_class) { method_value } }
              .to delegate_to(ConvenientService::Utils::Array, :limited_push)
              .with_arguments(exception.services, service_details, limit: ConvenientService::Service::Plugins::CollectsServicesInException::Constants::DEFAULT_MAX_SERVICES_SIZE)
          end

          it "reraises exception" do
            expect { method_value }
              .to raise_error(exception_class)
              .with_message(exception_message)
          end
        end

        context "when `max_services_size` is passed" do
          let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware.with(max_services_size: max_services_size)) }

          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(exception, middleware, max_services_size) do |exception, middleware, max_services_size|
                include ConvenientService::Service::Configs::Standard

                middlewares :result do
                  replace middleware, middleware.with(max_services_size: max_services_size)

                  observe middleware.with(max_services_size: max_services_size)
                end

                def result
                  raise exception
                end

                define_method(:exception) { exception }
              end
            end
          end

          let(:max_services_size) { 5 }

          specify do
            allow(service_instance).to receive(:exception).and_return(exception)

            ##
            # NOTE: Called in order to define `services` method on exception.
            #
            ignoring_exception(exception_class) { method.call }

            expect { ignoring_exception(exception_class) { method.call } }
              .to delegate_to(ConvenientService::Utils::Array, :limited_push)
              .with_arguments(exception.services, service_details, limit: max_services_size)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
