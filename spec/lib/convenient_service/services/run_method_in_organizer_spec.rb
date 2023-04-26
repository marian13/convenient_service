# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Services::RunMethodInOrganizer do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:service_result) { described_class.result(method_name: method_name, organizer: organizer, **kwargs) }

      let(:organizer_base_service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, method_return_value) do |method_name, method_return_value|
            include ConvenientService::Service::Plugins::HasResult::Concern
          end
        end
      end

      let(:organizer_service_class) do
        Class.new(organizer_base_service_class).tap do |klass|
          klass.class_exec(method_name, method_return_value) do |method_name, method_return_value|
            # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                end
              end
            end
            # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

            define_method(method_name) { success(data: {value: method_return_value}) }
          end
        end
      end

      let(:method_return_value) { :bar }

      let(:method_name) { :foo }
      let(:organizer) { organizer_service_class.new }
      let(:kwargs) { {} }

      it "calls method in `organizer` context" do
        expect(service_result).to be_success.with_data(value: method_return_value)
      end

      context "when `kwargs` are passed" do
        let(:organizer_service_class) do
          Class.new(organizer_base_service_class).tap do |klass|
            klass.class_exec(method_name) do |method_name|
              # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
              class self::Result
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Concern
                  use ConvenientService::Common::Plugins::HasConstructor::Concern
                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern
                end

                middlewares :initialize do
                  use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
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

        let(:kwargs) { {foo: :bar} }

        it "ignores them" do
          expect(service_result).to be_success.with_data(kwargs: {})
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
