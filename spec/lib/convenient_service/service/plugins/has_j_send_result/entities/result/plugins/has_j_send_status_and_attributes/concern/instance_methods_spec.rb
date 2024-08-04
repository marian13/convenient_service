# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:service_instance) { service_class.new }

  let(:result_class) { service_class.result_class }

  let(:result_instance) { result_class.new(**params) }

  let(:params) do
    {
      service: service_instance,
      status: status,
      data: {foo: :bar},
      message: "foo",
      code: :foo,
      **extra_kwargs
    }
  end

  let(:status) { :foo }

  let(:extra_kwargs) { {} }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

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
        expect(result_instance.service).to eq(params[:service])
      end
    end

    describe "#status" do
      it "returns casted `status`" do
        expect(result_instance.status).to eq(result_class.status(value: params[:status]))
      end
    end

    describe "#data" do
      before do
        result_instance.success?
      end

      it "returns casted `data`" do
        expect(result_instance.data).to eq(result_class.data(value: params[:data]))
      end
    end

    describe "#unsafe_data" do
      it "returns casted `data`" do
        expect(result_instance.unsafe_data).to eq(result_class.data(value: params[:data]))
      end
    end

    describe "#message" do
      before do
        result_instance.success?
      end

      it "returns casted `message`" do
        expect(result_instance.message).to eq(result_class.message(value: params[:message]))
      end
    end

    describe "#unsafe_message" do
      it "returns casted `message`" do
        expect(result_instance.unsafe_message).to eq(result_class.message(value: params[:message]))
      end
    end

    describe "#code" do
      before do
        result_instance.success?
      end

      it "returns casted `code`" do
        expect(result_instance.code).to eq(result_class.code(value: params[:code]))
      end
    end

    describe "#unsafe_code" do
      it "returns casted `code`" do
        expect(result_instance.unsafe_code).to eq(result_class.code(value: params[:code]))
      end
    end

    describe "#extra_kwargs" do
      let(:extra_kwargs) { {parent: nil} }

      it "returns casted JSend attributes" do
        expect(result_instance.extra_kwargs).to eq(extra_kwargs)
      end
    end

    describe "#jsend_attributes" do
      let(:jsend_attributes) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CastJSendAttributes.call(result: result_instance, kwargs: params) }

      it "returns casted JSend attributes" do
        expect(result_instance.jsend_attributes).to eq(jsend_attributes)
      end
    end

    describe "#create_status" do
      specify do
        expect { result_instance.create_status(params[:status]) }
          .to delegate_to(result_class, :status)
          .with_arguments(value: params[:status], result: result_instance)
          .and_return_its_value
      end
    end

    describe "#create_data" do
      specify do
        expect { result_instance.create_data(params[:data]) }
          .to delegate_to(result_class, :data)
          .with_arguments(value: params[:data], result: result_instance)
          .and_return_its_value
      end
    end

    describe "#create_message" do
      specify do
        expect { result_instance.create_message(params[:message]) }
          .to delegate_to(result_class, :message)
          .with_arguments(value: params[:message], result: result_instance)
          .and_return_its_value
      end
    end

    describe "#create_code" do
      specify do
        expect { result_instance.create_code(params[:code]) }
          .to delegate_to(result_class, :code)
          .with_arguments(value: params[:code], result: result_instance)
          .and_return_its_value
      end
    end

    describe "#==" do
      let(:result) { result_class.new(**params) }

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

      context "when results have different extra kwargs" do
        let(:other) { result_class.new(**params.merge(parent: nil)) }

        it "ignores them" do
          expect(result == other).to eq(true)
        end
      end

      context "when results have same attributes" do
        let(:other) { result_class.new(**params) }

        it "returns `true`" do
          expect(result == other).to eq(true)
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }

      let(:kwargs) do
        {
          service: service_instance,
          status: result_instance.create_status(:foo),
          data: result_instance.create_data({foo: :bar}),
          message: result_instance.create_message("foo"),
          code: result_instance.create_code(:foo)
        }
      end

      describe "#to_kwargs" do
        specify do
          allow(result_instance).to receive(:to_arguments).and_return(arguments)

          expect { result_instance.to_kwargs }
            .to delegate_to(result_instance.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end

        specify { expect { result_instance.to_kwargs }.to delegate_to(result_instance, :unsafe_data) }
        specify { expect { result_instance.to_kwargs }.to delegate_to(result_instance, :unsafe_message) }
        specify { expect { result_instance.to_kwargs }.to delegate_to(result_instance, :unsafe_code) }

        context "when `result` has extra kwargs" do
          let(:extra_kwargs) { {parent: nil} }

          it "includes them into kwargs representation of result" do
            expect(result_instance.to_kwargs).to eq(kwargs.merge(extra_kwargs))
          end

          specify { expect { result_instance.to_kwargs }.to delegate_to(result_instance, :extra_kwargs) }
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of result" do
          expect(result_instance.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
