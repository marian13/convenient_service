# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultMethodSteps::Services::RunOwnMethodInOrganizer do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Service::Plugins::HasResultMethodSteps::Services::MethodStepConfig) }
  end

  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:service_result) { described_class.result(method_name: method_name, organizer: organizer, **kwargs) }

      let(:organizer_base_service_class) do
        Class.new.tap do |klass|
          klass.class_exec(prepend_module, method_name) do |prepend_module, method_name|
            include ConvenientService::Service::Plugins::HasResult::Concern

            ##
            # NOTE: Used to confirm that own is called, not prepended method.
            #
            prepend prepend_module
          end
        end
      end

      let(:prepend_module) do
        Module.new.tap do |mod|
          mod.module_exec(method_name) do |method_name|
            define_method(method_name) { failure }
          end
        end
      end

      let(:method_name) { :foo }
      let(:organizer) { organizer_service_class.new }
      let(:kwargs) { {} }

      context "when `organizer` does NOT have own method" do
        let(:organizer_service_class) { organizer_base_service_class }

        let(:error_message) do
          <<~TEXT
            Service #{organizer.class} tries to use `#{method_name}` method in a step, but it NOT defined.

            Did you forget to define it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResultMethodSteps::Errors::MethodForStepIsNotDefined`" do
          expect { service_result }
            .to raise_error(ConvenientService::Service::Plugins::HasResultMethodSteps::Errors::MethodForStepIsNotDefined)
            .with_message(error_message)
        end
      end

      context "when `organizer` has own method" do
        let(:organizer_service_class) do
          Class.new(organizer_base_service_class).tap do |klass|
            klass.class_exec(method_name) do |method_name|
              # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
              class self::Result
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Concern
                  use ConvenientService::Common::Plugins::HasConstructor::Concern
                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
                end

                middlewares :initialize do
                  use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
                end

                class self::Internals
                  include ConvenientService::Core

                  concerns do
                    use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                  end
                end
              end
              # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

              define_method(method_name) { success }
            end
          end
        end

        it "calls that own method" do
          ##
          # NOTE: Own method returns `success`, while prepended returns `failure`.
          # See `organizer_service_class` definition above.
          #
          expect(service_result).to be_success
        end

        context "when `kwargs` are passed" do
          # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
          let(:organizer_service_class) do
            Class.new(organizer_base_service_class).tap do |klass|
              klass.class_exec(method_name) do |method_name|
                # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
                class self::Result
                  include ConvenientService::Core

                  concerns do
                    use ConvenientService::Common::Plugins::HasInternals::Concern
                    use ConvenientService::Common::Plugins::HasConstructor::Concern
                    use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
                  end

                  middlewares :initialize do
                    use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                    use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
                  end

                  class self::Internals
                    include ConvenientService::Core

                    concerns do
                      use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                    end
                  end
                end
                # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

                define_method(method_name) { |**kwargs| success(data: {kwargs: kwargs}) }
              end
            end
          end
          # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

          let(:kwargs) { {foo: :bar} }

          it "ignores them" do
            expect(service_result).to be_success.with_data(kwargs: {})
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
