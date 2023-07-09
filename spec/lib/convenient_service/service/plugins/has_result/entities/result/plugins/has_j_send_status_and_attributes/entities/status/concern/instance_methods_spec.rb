# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:status) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: value, result: result) }
  let(:value) { :foo }
  let(:result) { double }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `result` is NOT passed" do
        let(:status) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :foo) }

        it "defaults to `nil`" do
          expect(status.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { status }

      it { is_expected.to have_attr_reader(:value) }
      it { is_expected.to have_attr_reader(:result) }
    end

    describe "#success?" do
      context "when `value` is NOT `:success`" do
        it "returns `false`" do
          expect(status.success?).to eq(false)
        end
      end

      context "when `value` is `:success`" do
        let(:value) { :success }

        it "returns `true`" do
          expect(status.success?).to eq(true)
        end
      end
    end

    describe "#failure?" do
      context "when `value` is NOT `:failure`" do
        it "returns `false`" do
          expect(status.failure?).to eq(false)
        end
      end

      context "when `value` is `:failure`" do
        let(:value) { :failure }

        it "returns `true`" do
          expect(status.failure?).to eq(true)
        end
      end
    end

    describe "#error?" do
      context "when `value` is NOT `:error`" do
        it "returns `false`" do
          expect(status.error?).to eq(false)
        end
      end

      context "when `value` is `:error`" do
        let(:value) { :error }

        it "returns `true`" do
          expect(status.error?).to eq(true)
        end
      end
    end

    describe "#not_success?" do
      context "when `value` is NOT `:success`" do
        it "returns `true`" do
          expect(status.not_success?).to eq(true)
        end
      end

      context "when `value` is `:success`" do
        let(:value) { :success }

        it "returns `false`" do
          expect(status.not_success?).to eq(false)
        end
      end
    end

    describe "#not_failure?" do
      context "when `value` is NOT `:failure`" do
        it "returns `true`" do
          expect(status.not_failure?).to eq(true)
        end
      end

      context "when `value` is `:failure`" do
        let(:value) { :failure }

        it "returns `false`" do
          expect(status.not_failure?).to eq(false)
        end
      end
    end

    describe "#not_error?" do
      context "when `value` is NOT `:error`" do
        it "returns `true`" do
          expect(status.not_error?).to eq(true)
        end
      end

      context "when `value` is `:error`" do
        let(:value) { :error }

        it "returns `false`" do
          expect(status.not_error?).to eq(false)
        end
      end
    end

    describe "#in?" do
      context "when `statuses` are NOT empty" do
        context "when `status` is NOT equal to any of those statuses" do
          let(:statuses) do
            [
              ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :bar, result: result),
              ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :baz, result: result)
            ]
          end

          it "returns `false`" do
            expect(status.in?(statuses)).to eq(false)
          end
        end

        context "when `status` is equal to any of those statuses" do
          let(:statuses) do
            [
              ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :bar, result: result),
              ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :foo, result: result)
            ]
          end

          it "returns `true`" do
            expect(status.in?(statuses)).to eq(true)
          end
        end
      end

      context "when `statuses` are empty" do
        let(:statuses) { [] }

        it "returns `false`" do
          expect(status.in?(statuses)).to eq(false)
        end
      end
    end

    example_group "comparisons" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(status == other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :bar, result: result) }

          it "returns `false`" do
            expect(status == other).to eq(false)
          end
        end

        context "when `other` has different `result.class`" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: value, result: Object.new) }

          it "returns `false`" do
            expect(status == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: value, result: result) }

          it "returns `true`" do
            expect(status == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {value: value, result: result} }

      describe "#to_kwargs" do
        specify do
          allow(status).to receive(:to_arguments).and_return(arguments)

          expect { status.to_kwargs }
            .to delegate_to(status.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { status.to_kwargs }.to cache_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of status" do
          expect(status.to_arguments).to eq(arguments)
        end

        specify do
          expect { status.to_arguments }.to cache_its_value
        end
      end

      describe "#to_s" do
        it "returns string representation of `status`" do
          expect(status.to_s).to eq("foo")
        end

        specify do
          expect { status.to_s }.to cache_its_value
        end
      end

      describe "#to_sym" do
        it "returns symbol representation of `status`" do
          expect(status.to_sym).to eq(:foo)
        end

        specify do
          expect { status.to_sym }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
