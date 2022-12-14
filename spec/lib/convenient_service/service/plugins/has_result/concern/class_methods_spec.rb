# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Concern::ClassMethods do
  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        extend mod

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

        def initialize(*args, **kwargs, &block)
        end

        def result
          "result"
        end
      end
    end
  end

  let(:service_instance) { service_class.new(*args, **kwargs, &block) }
  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".result" do
      specify do
        expect { service_class.result(*args, **kwargs, &block) }
          .to delegate_to(service_class, :new)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        allow(service_class).to receive(:new).and_return(service_instance)

        expect { service_class.result(*args, **kwargs, &block) }
          .to delegate_to(service_instance, :result)
          .and_return_its_value
      end
    end

    describe "#success" do
      let(:result) { service_class.success(**params) }
      let(:params) { {service: service_instance, data: data} }
      let(:data) { {foo: :bar} }

      it "passes `service` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(service: service_instance)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::SUCCESS_STATUS` as `status` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(status: ConvenientService::Service::Plugins::HasResult::Constants::SUCCESS_STATUS)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "passes `data` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(data: data)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::SUCCESS_MESSAGE` as `message` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(message: ConvenientService::Service::Plugins::HasResult::Constants::SUCCESS_MESSAGE)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::SUCCESS_CODE` as `code` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(code: ConvenientService::Service::Plugins::HasResult::Constants::SUCCESS_CODE)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:service])) }

        it "defaults `service` to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SERVICE_INSTANCE`" do
          expect(result.service).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SERVICE_INSTANCE)
        end
      end

      context "when `data` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:data])) }

        it "defaults `data` to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAUTL_SUCCESS_DATA`" do
          expect(result.data).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SUCCESS_DATA)
        end
      end
    end

    describe "#failure" do
      let(:result) { service_class.failure(**params) }
      let(:params) { {service: service_instance, data: data, message: message} }
      let(:data) { {foo: "bar"} }
      let(:message) { "foo" }
      let(:first_pair_message) { data.first.join(" ") }

      it "passes `service` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(service: service_instance)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::FAILURE_STATUS` as `status` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(status: ConvenientService::Service::Plugins::HasResult::Constants::FAILURE_STATUS)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "passes `data` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(data: data)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "passes `message` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(message: message)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::FAILURE_CODE` as `code` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(code: ConvenientService::Service::Plugins::HasResult::Constants::FAILURE_CODE)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:service])) }

        it "defaults `service` to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SERVICE_INSTANCE`" do
          expect(result.service).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SERVICE_INSTANCE)
        end
      end

      context "when `data` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:data])) }

        it "defaults `data` to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_FAILURE_DATA`" do
          expect(result.data).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_FAILURE_DATA)
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:message])) }

        it "defaults `message` to concatenated by space first key and first value from `data`" do
          expect(result.message).to eq(first_pair_message)
        end

        context "when `data` is empty" do
          let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:message]).merge(data: {})) }

          it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_FAILURE_MESSAGE` as `message` to result constructor" do
            allow(service_class.result_class).to receive(:new).with(hash_including(message: ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_FAILURE_MESSAGE)).and_call_original

            result

            expect(service_class.result_class).to have_received(:new)
          end
        end
      end
    end

    describe "#error" do
      let(:result) { service_class.error(**params) }
      let(:params) { {service: service_instance, message: message, code: code} }
      let(:message) { "foo" }
      let(:code) { :custom }

      it "passes `service` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(service: service_instance)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "internally passes `ConvenientService::Service::Plugins::HasResult::Constants::ERROR_STATUS` as `status` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(status: ConvenientService::Service::Plugins::HasResult::Constants::ERROR_STATUS)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "passes `message` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(message: message)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      it "passes `code` to result constructor" do
        allow(service_class.result_class).to receive(:new).with(hash_including(code: code)).and_call_original

        result

        expect(service_class.result_class).to have_received(:new)
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:service])) }

        it "defaults service to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SERVICE_INSTANCE`" do
          expect(result.service).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_SERVICE_INSTANCE)
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:message])) }

        it "defaults `message` to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_ERROR_MESSAGE`" do
          expect(result.message).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_ERROR_MESSAGE)
        end
      end

      context "when `code` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:code])) }

        it "defaults `code` to `ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_ERROR_CODE`" do
          expect(result.code).to eq(ConvenientService::Service::Plugins::HasResult::Constants::DEFAULT_ERROR_CODE)
        end
      end
    end

    describe ".result_class" do
      it "delegates to `ConvenientService::Service::Plugins::HasResult::Commands::CreateResultClass`" do
        allow(ConvenientService::Service::Plugins::HasResult::Commands::CreateResultClass).to receive(:call).with(hash_including(service_class: service_class)).and_call_original

        service_class.result_class

        expect(ConvenientService::Service::Plugins::HasResult::Commands::CreateResultClass).to have_received(:call)
      end

      it "returns `ConvenientService::Service::Plugins::HasResult::Commands::CreateResultClass` result" do
        expect(service_class.result_class).to eq(ConvenientService::Service::Plugins::HasResult::Commands::CreateResultClass.call(service_class: service_class))
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
