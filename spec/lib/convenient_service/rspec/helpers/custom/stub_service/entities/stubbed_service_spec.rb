# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubbedService do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results

  subject(:helper) { described_class.new(service_class: service_class) }

  ##
  # TODO: Service class factory!
  #
  # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
  let(:service_class) do
    Class.new do
      include ConvenientService::Core

      concerns do
        use ConvenientService::Service::Plugins::CanHaveStubbedResult::Concern
        use ConvenientService::Common::Plugins::HasConstructor::Concern
        use ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern
        use ConvenientService::Service::Plugins::HasResult::Concern
      end

      middlewares :result, scope: :class do
        use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

        use ConvenientService::Service::Plugins::CanHaveStubbedResult::Middleware
      end

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

      class self::Internals
        include ConvenientService::Core

        concerns do
          use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
        end
      end

      def result
        success
      end
    end
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:result_spec) { ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec.new(status: :success) }
  let(:result_value) { result_spec.for(service_class).calculate_value }

  example_group "instance methods" do
    describe "#with_arguments" do
      it "returns self" do
        expect(helper.with_arguments(*args, **kwargs, &block)).to eq(helper)
      end

      context "when method is NOT called with arguments" do
        it "does NOT modify method to return stub" do
          stub_service(service_class).with_arguments(*args, **kwargs, &block).to return_error.with_code(:with_arguments)

          expect(service_class.result).to be_success
        end
      end

      context "when method is called with arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).with_arguments(*args, **kwargs, &block).to return_error.with_code(:with_arguments)

          expect(service_class.result(*args, **kwargs, &block)).to be_error.with_code(:with_arguments)
        end
      end
    end

    describe "#without_arguments" do
      it "returns self" do
        expect(helper.without_arguments).to eq(helper)
      end

      context "when method is NOT called without arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).without_arguments.to return_error.with_code(:with_arguments)

          expect(service_class.result(*args, **kwargs, &block)).to be_error.with_code(:with_arguments)
        end
      end

      context "when method is called without arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).without_arguments.to return_error.with_code(:with_arguments)

          expect(service_class.result).to be_error.with_code(:with_arguments)
        end
      end
    end

    describe "#to" do
      let(:key) { service_class.stubbed_results.keygen }

      it "returns `self`" do
        expect(helper.to(result_spec)).to eq(helper)
      end

      it "commits `service_class` config" do
        expect { helper.to(result_spec) }
          .to delegate_to(service_class, :commit_config!)
          .with_arguments(trigger: ConvenientService::RSpec::Helpers::Custom::StubService::Constants::Triggers::STUB_SERVICE)
      end

      it "writes `result_spec` to `stubbed_results` cache" do
        ##
        # TODO: Add `without_arguments`.
        #
        expect { helper.to(result_spec) }
          .to delegate_to(service_class.stubbed_results, :write)
          .with_arguments(key, result_value)
      end

      context "when used with `with_arguments`" do
        let(:key) { service_class.stubbed_results.keygen(*args, **kwargs, &block) }

        it "writes `result_spec` to `stubbed_results` cache with arguments" do
          expect { helper.with_arguments(*args, **kwargs, &block).to(result_spec) }
            .to delegate_to(service_class.stubbed_results, :write)
            .with_arguments(key, result_value)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
