# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern::InstanceMethods do
  let(:result) { result_class.new(**params) }

  # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
  let(:result_class) do
    Class.new do
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
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

  let(:params) do
    {
      service: service_instance,
      status: :foo,
      data: {foo: :bar},
      message: "foo",
      code: :foo
    }
  end

  let(:service_class) { Class.new }
  let(:service_instance) { service_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { result.class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { result }
  #
  #   it { is_expected.to delegate_method(:success?).to(:status) }
  #   it { is_expected.to delegate_method(:failure?).to(:status) }
  #   it { is_expected.to delegate_method(:error?).to(:status) }
  #   it { is_expected.to delegate_method(:not_success?).to(:status) }
  #   it { is_expected.to delegate_method(:not_failure?).to(:status) }
  #   it { is_expected.to delegate_method(:not_error?).to(:status) }
  # end

  example_group "instance methods" do
    describe "#service" do
      it "returns `service`" do
        expect(result.service).to eq(params[:service])
      end
    end

    describe "#status" do
      it "returns casted `status`" do
        expect(result.status).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Status.cast(params[:status]))
      end
    end

    describe "#data" do
      it "returns casted `data`" do
        expect(result.data).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data.cast(params[:data]))
      end
    end

    describe "#unsafe_data" do
      it "returns casted `data`" do
        expect(result.unsafe_data).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data.cast(params[:data]))
      end
    end

    describe "#message" do
      it "returns casted `message`" do
        expect(result.message).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast(params[:message]))
      end
    end

    describe "#unsafe_message" do
      it "returns casted `message`" do
        expect(result.unsafe_message).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast(params[:message]))
      end
    end

    describe "#code" do
      it "returns casted `code`" do
        expect(result.code).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Code.cast(params[:code]))
      end
    end

    describe "#unsafe_code" do
      it "returns casted `code`" do
        expect(result.unsafe_code).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Code.cast(params[:code]))
      end
    end

    describe "#jsend_attributes" do
      let(:jsend_attributes) do
        ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Structs::JSendAttributes.new(
          service: params[:service],
          status: ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Status.cast(params[:status]),
          data: ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data.cast(params[:data]),
          message: ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast(params[:message]),
          code: ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Code.cast(params[:code])
        )
      end

      it "returns casted JSend attributes" do
        expect(result.jsend_attributes).to eq(jsend_attributes)
      end
    end

    describe "#==" do
      context "when results have different classes" do
        let(:other) { "string" }

        it "returns `nil`" do
          expect(result == other).to eq(nil)
        end
      end

      context "when results have different services" do
        context "when those services has different classes" do
          let(:other) { result_class.new(**params.merge(service: Object.new)) }

          it "returns `false`" do
            expect(result == other).to eq(false)
          end
        end

        context "when those services has same classes" do
          let(:other) { result_class.new(**params.merge(service: service_class.new)) }

          it "returns `false`" do
            expect(result == other).to eq(true)
          end
        end
      end

      context "when results have different status" do
        let(:other) { result_class.new(**params.merge(status: :bar)) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have different data" do
        let(:other) { result_class.new(**params.merge(data: {bar: :foo})) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have different messages" do
        let(:other) { result_class.new(**params.merge(message: "bar")) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have different code" do
        let(:other) { result_class.new(**params.merge(code: :bar)) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have same attributes" do
        let(:other) { result_class.new(**params) }

        it "returns `true`" do
          expect(result == other).to eq(true)
        end
      end
    end

    describe "#to_kwargs" do
      let(:kwargs) { params }

      it "returns kwargs representation of result" do
        expect(result.to_kwargs).to eq(kwargs)
      end

      specify { expect { result.to_kwargs }.to delegate_to(result, :unsafe_data) }
      specify { expect { result.to_kwargs }.to delegate_to(result, :unsafe_message) }
      specify { expect { result.to_kwargs }.to delegate_to(result, :unsafe_code) }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
