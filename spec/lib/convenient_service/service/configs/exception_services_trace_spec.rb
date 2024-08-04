# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::ExceptionServicesTrace, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Essential) }

      example_group "service" do
        example_group "#initialize middlewares" do
          it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#initialize`" do
            expect(service_class.middlewares(:initialize).to_a.first).to eq(ConvenientService::Service::Plugins::CollectsServicesInException::Middleware)
          end
        end

        example_group "#result middlewares" do
          it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.first).to eq(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
          end
        end

        example_group "#negated_result middlewares" do
          it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#negated_result`" do
            expect(service_class.middlewares(:negated_result).to_a.first).to eq(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
          end
        end

        context "when service class does NOT include `Fallbacks` config" do
          example_group "#fallback_failure_result middlewares" do
            it "does NOT add `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#fallback_failure_result`" do
              expect(service_class.middlewares(:fallback_failure_result).to_a).not_to include(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
            end
          end

          example_group "#fallback_error_result middlewares" do
            it "does NOT add `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#fallback_error_result`" do
              expect(service_class.middlewares(:fallback_error_result).to_a).not_to include(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
            end
          end

          example_group "#fallback_result middlewares" do
            it "does NOT add `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#fallback_result`" do
              expect(service_class.middlewares(:fallback_result).to_a).not_to include(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
            end
          end
        end

        context "when service class includes `Fallbacks` config" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(described_class) do |mod|
                include ConvenientService::Service::Configs::Fallbacks

                include mod
              end
            end
          end

          example_group "#fallback_failure_result middlewares" do
            it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#fallback_failure_result`" do
              expect(service_class.middlewares(:fallback_failure_result).to_a.first).to eq(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
            end
          end

          example_group "#fallback_error_result middlewares" do
            it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#fallback_error_result`" do
              expect(service_class.middlewares(:fallback_error_result).to_a.first).to eq(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
            end
          end

          example_group "#fallback_result middlewares" do
            it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#fallback_result`" do
              expect(service_class.middlewares(:fallback_result).to_a.first).to eq(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
