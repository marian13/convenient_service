# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# TODO: Integration specs.
#
# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result do
  let(:result) { described_class.new(**params) }

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
  # example_group "delegations" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { result }
  #
  #   it { is_expected.to delegate_method(:service).to(:params) }
  #   it { is_expected.to delegate_method(:status).to(:params) }
  #   it { is_expected.to delegate_method(:data).to(:params) }
  #   it { is_expected.to delegate_method(:message).to(:params) }
  #   it { is_expected.to delegate_method(:code).to(:params) }
  #
  #   it { is_expected.to delegate_method(:success?).to(:status) }
  #   it { is_expected.to delegate_method(:failure?).to(:status) }
  #   it { is_expected.to delegate_method(:error?).to(:status) }
  #   it { is_expected.to delegate_method(:not_success?).to(:status) }
  #   it { is_expected.to delegate_method(:not_failure?).to(:status) }
  #   it { is_expected.to delegate_method(:not_error?).to(:status) }
  # end

  example_group "class methods" do
    describe ".new" do
      it "delegates to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Commands::CastResultParams`" do
        allow(ConvenientService::Service::Plugins::HasResult::Entities::Result::Commands::CastResultParams).to receive(:call).with(hash_including(params: params)).and_call_original

        result

        expect(ConvenientService::Service::Plugins::HasResult::Entities::Result::Commands::CastResultParams).to have_received(:call)
      end
    end
  end

  example_group "instance methods" do
    describe "#service" do
      it "returns `service`" do
        expect(result.service).to eq(params[:service])
      end
    end

    describe "#status" do
      it "returns casted `status`" do
        expect(result.status).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Status.cast(params[:status]))
      end
    end

    describe "#data" do
      it "returns casted `data`" do
        expect(result.data).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.cast(params[:data]))
      end
    end

    describe "#message" do
      it "returns casted `message`" do
        expect(result.message).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Message.cast(params[:message]))
      end
    end

    describe "#code" do
      it "returns casted `code`" do
        expect(result.code).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.cast(params[:code]))
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
          let(:other) { described_class.new(**params.merge(service: Object.new)) }

          it "returns `false`" do
            expect(result == other).to eq(false)
          end
        end

        context "when those services has same classes" do
          let(:other) { described_class.new(**params.merge(service: service_class.new)) }

          it "returns `false`" do
            expect(result == other).to eq(true)
          end
        end
      end

      context "when results have different status" do
        let(:other) { described_class.new(**params.merge(status: :bar)) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have different data" do
        let(:other) { described_class.new(**params.merge(data: {bar: :foo})) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have different messages" do
        let(:other) { described_class.new(**params.merge(message: "bar")) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have different code" do
        let(:other) { described_class.new(**params.merge(code: :bar)) }

        it "returns `false`" do
          expect(result == other).to eq(false)
        end
      end

      context "when results have same attributes" do
        let(:other) { described_class.new(**params) }

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
    end
  end
end
# rubocop:enable RSpec/NestedGroups
