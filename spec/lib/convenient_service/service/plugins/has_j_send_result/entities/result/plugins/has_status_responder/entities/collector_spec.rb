# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:collector) { described_class.new(result: result, block: block, handlers: handlers, unexpected_handler: unexpected_handler) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:result) { service.result }

  let(:block) do
    proc do |status|
      status.success { success_block_value }
    end
  end

  let(:success_block_value) { "success block value" }

  let(:handlers) { [] }

  let(:unexpected_handler) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::UnexpectedHandler.new(block: proc {}) }

  example_group "class methods" do
    describe ".new" do
      context "when `handlers` kwarg is NOT passed" do
        let(:collector) { described_class.new(result: result, block: block, unexpected_handler: unexpected_handler) }

        it "defaults to empty array" do
          expect(collector.handlers).to eq([])
        end
      end

      context "when `unexpected_handler` kwarg is NOT passed" do
        let(:collector) { described_class.new(result: result, block: block, handlers: handlers) }

        it "defaults to `nil`" do
          expect(collector.unexpected_handler).to eq(nil)
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { collector }

      it { is_expected.to have_attr_reader(:result) }
      it { is_expected.to have_attr_reader(:block) }
      it { is_expected.to have_attr_reader(:handlers) }
      it { is_expected.to have_attr_reader(:unexpected_handler) }
    end

    describe "#success" do
      let(:success_block) do
        proc { success_block_value }
      end

      let(:success_block_value) { "success block value" }

      specify do
        expect { collector.success(&success_block) }
          .to delegate_to(collector.handlers, :<<)
            .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :success, data: nil, message: nil, code: nil, block: success_block))
            .and_return { collector }
      end

      context "when `data` kwargs is passed" do
        let(:data) { {foo: :bar} }

        specify do
          expect { collector.success(data: data, &success_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :success, data: data, message: nil, code: nil, block: success_block))
              .and_return { collector }
        end
      end

      context "when `message` kwargs is passed" do
        let(:message) { "foo" }

        specify do
          expect { collector.success(message: message, &success_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :success, data: nil, message: message, code: nil, block: success_block))
              .and_return { collector }
        end
      end

      context "when `code` kwargs is passed" do
        let(:code) { :foo }

        specify do
          expect { collector.success(code: code, &success_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :success, data: nil, message: nil, code: code, block: success_block))
              .and_return { collector }
        end
      end
    end

    describe "#failure" do
      let(:failure_block) do
        proc { failure_block_value }
      end

      let(:failure_block_value) { "failure block value" }

      specify do
        expect { collector.failure(&failure_block) }
          .to delegate_to(collector.handlers, :<<)
            .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :failure, data: nil, message: nil, code: nil, block: failure_block))
            .and_return { collector }
      end

      context "when `data` kwargs is passed" do
        let(:data) { {foo: :bar} }

        specify do
          expect { collector.failure(data: data, &failure_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :failure, data: data, message: nil, code: nil, block: failure_block))
              .and_return { collector }
        end
      end

      context "when `message` kwargs is passed" do
        let(:message) { "foo" }

        specify do
          expect { collector.failure(message: message, &failure_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :failure, data: nil, message: message, code: nil, block: failure_block))
              .and_return { collector }
        end
      end

      context "when `code` kwargs is passed" do
        let(:code) { :foo }

        specify do
          expect { collector.failure(code: code, &failure_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :failure, data: nil, message: nil, code: code, block: failure_block))
              .and_return { collector }
        end
      end
    end

    describe "#error" do
      let(:error_block) do
        proc { error_block_value }
      end

      let(:error_block_value) { "error block value" }

      specify do
        expect { collector.error(&error_block) }
          .to delegate_to(collector.handlers, :<<)
            .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :error, data: nil, message: nil, code: nil, block: error_block))
            .and_return { collector }
      end

      context "when `data` kwargs is passed" do
        let(:data) { {foo: :bar} }

        specify do
          expect { collector.error(data: data, &error_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :error, data: data, message: nil, code: nil, block: error_block))
              .and_return { collector }
        end
      end

      context "when `message` kwargs is passed" do
        let(:message) { "foo" }

        specify do
          expect { collector.error(message: message, &error_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :error, data: nil, message: message, code: nil, block: error_block))
              .and_return { collector }
        end
      end

      context "when `code` kwargs is passed" do
        let(:code) { :foo }

        specify do
          expect { collector.error(code: code, &error_block) }
            .to delegate_to(collector.handlers, :<<)
              .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler.new(result: result, status: :error, data: nil, message: nil, code: code, block: error_block))
              .and_return { collector }
        end
      end
    end

    describe "#unexpected" do
      let(:unexpected_block) do
        proc { unexpected_block_value }
      end

      let(:unexpected_block_value) { "unexpected block value" }

      it "sets unexpected handler" do
        collector.unexpected(&unexpected_block)

        expect(collector.unexpected_handler).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::UnexpectedHandler.new(block: unexpected_block))
      end

      it "returns collector" do
        expect(collector.unexpected(&unexpected_block)).to eq(collector)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:collector) { described_class.new(result: result, block: block, handlers: handlers, unexpected_handler: unexpected_handler) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(collector == other).to be_nil
          end
        end

        context "when `other` has different `result`" do
          let(:other) { described_class.new(result: service.failure, block: block, handlers: handlers, unexpected_handler: unexpected_handler) }

          it "returns `false`" do
            expect(collector == other).to eq(false)
          end
        end

        context "when `other` has different `block`" do
          let(:other) { described_class.new(result: result, block: proc {}, handlers: handlers, unexpected_handler: unexpected_handler) }

          it "returns `false`" do
            expect(collector == other).to eq(false)
          end
        end

        context "when `other` has different `handlers`" do
          let(:other) { described_class.new(result: result, block: block, handlers: [], unexpected_handler: unexpected_handler).success {} }

          it "returns `false`" do
            expect(collector == other).to eq(false)
          end
        end

        context "when `other` has different `unexpected_handler`" do
          let(:other) { described_class.new(result: result, block: block, handlers: handlers, unexpected_handler: unexpected_handler).unexpected {} }

          it "returns `false`" do
            expect(collector == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(result: result, block: block, handlers: handlers, unexpected_handler: unexpected_handler) }

          it "returns `true`" do
            expect(collector == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
