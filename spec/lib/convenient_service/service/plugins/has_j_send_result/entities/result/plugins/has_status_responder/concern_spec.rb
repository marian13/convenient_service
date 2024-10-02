# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Concern, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#respond_to" do
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
          status.success { :foo }
        end
      end

      let(:collector) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector.new(result: result, block: block) }

      specify do
        expect { result.respond_to(&block) }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector, :new)
          .with_arguments(result: result, block: block)
      end

      specify do
        allow(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector).to receive(:new).and_return(collector)

        expect { result.respond_to(&block) }
          .to delegate_to(collector, :handle)
          .without_arguments
          .and_return_its_value
      end

      example_group "comprehensive suite" do
        let(:unexpected_handler_block_value) { "unexpected handler block value" }

        ##
        # NOTE: `evaluation_tracker.raise` is used in places that must NOT be evaluated. Previously, regular `raise_error` was used, but it emits fair warnings.
        # - https://github.com/decidim/decidim/issues/7369
        #
        let(:evaluation_tracker) { Class.new }

        before do
          allow(evaluation_tracker).to receive(:raise).with(instance_of(String))
        end

        context "when `collector` has NO handlers" do
          context "when `collector` does NOT have `unexpected` handler" do
            let(:block) { proc {} }

            it "returns `nil`" do
              expect(result.respond_to(&block)).to be_nil
            end
          end

          context "when `collector` has `unexpected` handler" do
            let(:block) do
              proc do |status|
                status.unexpected { unexpected_handler_block_value }
              end
            end

            it "returns `unexpected` handler block value" do
              expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
            end
          end
        end

        context "when `collector` has one handler" do
          context "when that one handler is `success` handler" do
            let(:success_handler_block_value) { "success handler block value" }

            context "when that one `success` handler is NOT matched" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    failure
                  end
                end
              end

              context "when `collector` does NOT have `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.success { success_handler_block_value }
                  end
                end

                it "returns `nil`" do
                  expect(result.respond_to(&block)).to be_nil
                end
              end

              context "when `collector` has `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.success { success_handler_block_value }
                    status.unexpected { unexpected_handler_block_value }
                  end
                end

                it "returns `unexpected` handler block value" do
                  expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                end
              end
            end

            context "when that one `success` handler is matched" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success
                  end
                end
              end

              context "when `collector` does NOT have `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.success { success_handler_block_value }
                  end
                end

                it "returns that one `success` handler block value" do
                  expect(result.respond_to(&block)).to eq(success_handler_block_value)
                end
              end

              context "when `collector` has `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.success { success_handler_block_value }
                    status.unexpected { evaluation_tracker.raise "unexpected handler" }
                  end
                end

                it "returns that one `success` handler block value" do
                  expect(result.respond_to(&block)).to eq(success_handler_block_value)
                end

                it "does NOT evaluate `unexpected` handler" do
                  result.respond_to(&block)

                  expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                end
              end
            end
          end

          context "when that one handler is `failure` handler" do
            let(:failure_handler_block_value) { "failure handler block value" }

            context "when that one `failure` handler is NOT matched" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    error
                  end
                end
              end

              context "when `collector` does NOT have `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.failure { failure_handler_block_value }
                  end
                end

                it "returns `nil`" do
                  expect(result.respond_to(&block)).to be_nil
                end
              end

              context "when `collector` has `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.failure { failure_handler_block_value }
                    status.unexpected { unexpected_handler_block_value }
                  end
                end

                it "returns `unexpected` handler block value" do
                  expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                end
              end
            end

            context "when that one `failure` handler is matched" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    failure
                  end
                end
              end

              context "when `collector` does NOT have `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.failure { failure_handler_block_value }
                  end
                end

                it "returns that one `failure` handler block value" do
                  expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                end
              end

              context "when `collector` has `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.failure { failure_handler_block_value }
                    status.unexpected { evaluation_tracker.raise "unexpected handler" }
                  end
                end

                it "returns that one `failure` handler block value" do
                  expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                end

                it "does NOT evaluate `unexpected` handler" do
                  result.respond_to(&block)

                  expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                end
              end
            end
          end

          context "when that one handler is `error` handler" do
            let(:error_handler_block_value) { "error handler block value" }

            context "when that one `error` handler is NOT matched" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success
                  end
                end
              end

              context "when `collector` does NOT have `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.error { error_handler_block_value }
                  end
                end

                it "returns `nil`" do
                  expect(result.respond_to(&block)).to be_nil
                end
              end

              context "when `collector` has `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.error { error_handler_block_value }
                    status.unexpected { unexpected_handler_block_value }
                  end
                end

                it "returns `unexpected` handler block value" do
                  expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                end
              end
            end

            context "when that one `error` handler is matched" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    error
                  end
                end
              end

              context "when `collector` does NOT have `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.error { error_handler_block_value }
                  end
                end

                it "returns that one `error` handler block value" do
                  expect(result.respond_to(&block)).to eq(error_handler_block_value)
                end
              end

              context "when `collector` has `unexpected` handler" do
                let(:block) do
                  proc do |status|
                    status.error { error_handler_block_value }
                    status.unexpected { evaluation_tracker.raise "unexpected handler" }
                  end
                end

                it "returns that one `error` handler block value" do
                  expect(result.respond_to(&block)).to eq(error_handler_block_value)
                end

                it "does NOT evaluate `unexpected` handler" do
                  result.respond_to(&block)

                  expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                end
              end
            end
          end
        end

        context "when `collector` has multiple handlers" do
          context "when those handlers have same status" do
            context "when all those handlers are `success` handlers" do
              let(:first_success_handler_block_value) { "first success handler block value" }
              let(:second_success_handler_block_value) { "second success handler block value" }

              context "when NONE of those `success` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      failure
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.success { first_success_handler_block_value }
                      status.success { second_success_handler_block_value }
                    end
                  end

                  it "returns `nil`" do
                    expect(result.respond_to(&block)).to be_nil
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.success { first_success_handler_block_value }
                      status.success { second_success_handler_block_value }
                      status.unexpected { unexpected_handler_block_value }
                    end
                  end

                  it "returns `unexpected` handler block value" do
                    expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                  end
                end
              end

              context "when first of those `success` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      success(foo: :bar)
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.success(data: {foo: :bar}) { first_success_handler_block_value }
                      status.success(data: {baz: :qux}) { evaluation_tracker.raise "second `success` handler" }
                    end
                  end

                  it "returns that first matched `success` handler block value" do
                    expect(result.respond_to(&block)).to eq(first_success_handler_block_value)
                  end

                  it "does NOT evaluate second matched `success` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("second `success` handler")
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.success(data: {foo: :bar}) { first_success_handler_block_value }
                      status.success(data: {baz: :qux}) { evaluation_tracker.raise "second `success` handler" }
                      status.unexpected { evaluation_tracker.raise "unexpected handler" }
                    end
                  end

                  it "returns that first matched `success` handler block value" do
                    expect(result.respond_to(&block)).to eq(first_success_handler_block_value)
                  end

                  it "does NOT evaluate second matched `success` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("second `success` handler")
                  end

                  it "does NOT evaluate `unexpected` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                  end
                end
              end

              context "when second of those `success` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      success(baz: :qux)
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.success(data: {foo: :bar}) { evaluation_tracker.raise "first `success` handler" }
                      status.success(data: {baz: :qux}) { second_success_handler_block_value }
                    end
                  end

                  it "does NOT evaluate first matched `success` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("first `success` handler")
                  end

                  it "returns that second matched `success` handler block value" do
                    expect(result.respond_to(&block)).to eq(second_success_handler_block_value)
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.success(data: {foo: :bar}) { evaluation_tracker.raise "first `success` handler" }
                      status.success(data: {baz: :qux}) { second_success_handler_block_value }
                      status.unexpected { evaluation_tracker.raise "unexpected handler" }
                    end
                  end

                  it "does NOT evaluate first matched `success` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("first `success` handler")
                  end

                  it "returns that second matched `success` handler block value" do
                    expect(result.respond_to(&block)).to eq(second_success_handler_block_value)
                  end

                  it "does NOT evaluate `unexpected` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                  end
                end
              end

              context "when both of those `success` handlers are matched" do
                context "when both of those `success` handlers do NOT have same arguments" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(foo: :bar)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { first_success_handler_block_value }
                        status.success(data: {foo: :bar}) { evaluation_tracker.raise "second `success` handler" }
                      end
                    end

                    it "returns that first matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_success_handler_block_value)
                    end

                    it "does NOT evaluate second matched `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `success` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { first_success_handler_block_value }
                        status.success(data: {foo: :bar}) { evaluation_tracker.raise "second `success` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that first matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_success_handler_block_value)
                    end

                    it "does NOT evaluate second matched `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `success` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when both of those `success` handlers have same arguments" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(foo: :bar)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success(data: {foo: :bar}) { first_success_handler_block_value }
                        status.success(data: {foo: :bar}) { evaluation_tracker.raise "second `success` handler" }
                      end
                    end

                    it "returns that first matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_success_handler_block_value)
                    end

                    it "does NOT evaluate second matched `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `success` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success(data: {foo: :bar}) { first_success_handler_block_value }
                        status.success(data: {foo: :bar}) { evaluation_tracker.raise "second `success` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that first matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_success_handler_block_value)
                    end

                    it "does NOT evaluate second matched `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `success` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end
            end

            context "when all those handlers are `failure` handlers" do
              let(:first_failure_handler_block_value) { "first failure handler block value" }
              let(:second_failure_handler_block_value) { "second failure handler block value" }

              context "when NONE of those `failure` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      error
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.failure { first_failure_handler_block_value }
                      status.failure { second_failure_handler_block_value }
                    end
                  end

                  it "returns `nil`" do
                    expect(result.respond_to(&block)).to be_nil
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.failure { first_failure_handler_block_value }
                      status.failure { second_failure_handler_block_value }
                      status.unexpected { unexpected_handler_block_value }
                    end
                  end

                  it "returns `unexpected` handler block value" do
                    expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                  end
                end
              end

              context "when first of those `failure` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      failure("foo")
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.failure(message: "foo") { first_failure_handler_block_value }
                      status.failure(message: "bar") { evaluation_tracker.raise "second `failure` handler" }
                    end
                  end

                  it "returns that first matched `failure` handler block value" do
                    expect(result.respond_to(&block)).to eq(first_failure_handler_block_value)
                  end

                  it "does NOT evaluate second matched `failure` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("second `failure` handler")
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.failure(message: "foo") { first_failure_handler_block_value }
                      status.failure(message: "bar") { evaluation_tracker.raise "second `failure` handler" }
                      status.unexpected { evaluation_tracker.raise "unexpected handler" }
                    end
                  end

                  it "returns that first matched `failure` handler block value" do
                    expect(result.respond_to(&block)).to eq(first_failure_handler_block_value)
                  end

                  it "does NOT evaluate second matched `failure` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("second `failure` handler")
                  end

                  it "does NOT evaluate `unexpected` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                  end
                end
              end

              context "when second of those `failure` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      failure("bar")
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.failure(message: "foo") { evaluation_tracker.raise "first `failure` handler" }
                      status.failure(message: "bar") { second_failure_handler_block_value }
                    end
                  end

                  it "does NOT evaluate first matched `failure` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("first `failure` handler")
                  end

                  it "returns that second matched `failure` handler block value" do
                    expect(result.respond_to(&block)).to eq(second_failure_handler_block_value)
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.failure(message: "foo") { evaluation_tracker.raise "first `failure` handler" }
                      status.failure(message: "bar") { second_failure_handler_block_value }
                      status.unexpected { evaluation_tracker.raise "unexpected handler" }
                    end
                  end

                  it "does NOT evaluate first matched `failure` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("first `failure` handler")
                  end

                  it "returns that second matched `failure` handler block value" do
                    expect(result.respond_to(&block)).to eq(second_failure_handler_block_value)
                  end

                  it "does NOT evaluate `unexpected` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                  end
                end
              end

              context "when both of those `failure` handlers are matched" do
                context "when both of those `failure` handlers do NOT have same arguments" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure("foo")
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { first_failure_handler_block_value }
                        status.failure(message: "foo") { evaluation_tracker.raise "second `failure` handler" }
                      end
                    end

                    it "returns that first matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_failure_handler_block_value)
                    end

                    it "does NOT evaluate second matched `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `failure` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { first_failure_handler_block_value }
                        status.failure(message: "foo") { evaluation_tracker.raise "second `failure` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that first matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_failure_handler_block_value)
                    end

                    it "does NOT evaluate second matched `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `failure` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when both of those `failure` handlers have same arguments" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure("foo")
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure(message: "foo") { first_failure_handler_block_value }
                        status.failure(message: "foo") { evaluation_tracker.raise "second `failure` handler" }
                      end
                    end

                    it "returns that first matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_failure_handler_block_value)
                    end

                    it "does NOT evaluate second matched `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `failure` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure(message: "foo") { first_failure_handler_block_value }
                        status.failure(message: "foo") { evaluation_tracker.raise "second `failure` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that first matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_failure_handler_block_value)
                    end

                    it "does NOT evaluate second matched `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `failure` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end
            end

            context "when all those handlers are `error` handlers" do
              let(:first_error_handler_block_value) { "first error handler block value" }
              let(:second_error_handler_block_value) { "second error handler block value" }

              context "when NONE of those `error` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      success
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.error { first_error_handler_block_value }
                      status.error { second_error_handler_block_value }
                    end
                  end

                  it "returns `nil`" do
                    expect(result.respond_to(&block)).to be_nil
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.error { first_error_handler_block_value }
                      status.error { second_error_handler_block_value }
                      status.unexpected { unexpected_handler_block_value }
                    end
                  end

                  it "returns `unexpected` handler block value" do
                    expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                  end
                end
              end

              context "when first of those `error` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      error(code: :foo)
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.error(code: :foo) { first_error_handler_block_value }
                      status.error(code: :bar) { evaluation_tracker.raise "second `error` handler" }
                    end
                  end

                  it "returns that first matched `error` handler block value" do
                    expect(result.respond_to(&block)).to eq(first_error_handler_block_value)
                  end

                  it "does NOT evaluate second matched `error` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("second `error` handler")
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.error(code: :foo) { first_error_handler_block_value }
                      status.error(code: :bar) { evaluation_tracker.raise "second `error` handler" }
                      status.unexpected { evaluation_tracker.raise "unexpected handler" }
                    end
                  end

                  it "returns that first matched `error` handler block value" do
                    expect(result.respond_to(&block)).to eq(first_error_handler_block_value)
                  end

                  it "does NOT evaluate second matched `error` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("second `error` handler")
                  end

                  it "does NOT evaluate `unexpected` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                  end
                end
              end

              context "when second of those `error` handlers is matched" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      error(code: :bar)
                    end
                  end
                end

                context "when `collector` does NOT have `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.error(code: :foo) { evaluation_tracker.raise "first `error` handler" }
                      status.error(code: :bar) { second_error_handler_block_value }
                    end
                  end

                  it "does NOT evaluate first matched `error` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("first `error` handler")
                  end

                  it "returns that second matched `error` handler block value" do
                    expect(result.respond_to(&block)).to eq(second_error_handler_block_value)
                  end
                end

                context "when `collector` has `unexpected` handler" do
                  let(:block) do
                    proc do |status|
                      status.error(code: :foo) { evaluation_tracker.raise "first `error` handler" }
                      status.error(code: :bar) { second_error_handler_block_value }
                      status.unexpected { evaluation_tracker.raise "unexpected handler" }
                    end
                  end

                  it "does NOT evaluate first matched `error` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("first `error` handler")
                  end

                  it "returns that second matched `error` handler block value" do
                    expect(result.respond_to(&block)).to eq(second_error_handler_block_value)
                  end

                  it "does NOT evaluate `unexpected` handler" do
                    result.respond_to(&block)

                    expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                  end
                end
              end

              context "when both of those `error` handlers are matched" do
                context "when both of those `error` handlers do NOT have same arguments" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error(code: :foo)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { first_error_handler_block_value }
                        status.error(code: :foo) { evaluation_tracker.raise "second `error` handler" }
                      end
                    end

                    it "returns that first matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_error_handler_block_value)
                    end

                    it "does NOT evaluate second matched `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `error` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { first_error_handler_block_value }
                        status.error(code: :foo) { evaluation_tracker.raise "second `error` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that first matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_error_handler_block_value)
                    end

                    it "does NOT evaluate second matched `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `error` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when both of those `error` handlers have same arguments" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error(code: :foo)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error(code: :foo) { first_error_handler_block_value }
                        status.error(code: :foo) { evaluation_tracker.raise "second `error` handler" }
                      end
                    end

                    it "returns that first matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_error_handler_block_value)
                    end

                    it "does NOT evaluate second matched `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `error` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error(code: :foo) { first_error_handler_block_value }
                        status.error(code: :foo) { evaluation_tracker.raise "second `error` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that first matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(first_error_handler_block_value)
                    end

                    it "does NOT evaluate second matched `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("second `error` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end
            end
          end

          context "when those handlers have different statuses" do
            context "when first of those handlers is `success` handler" do
              context "when second of those handlers is `failure` handler" do
                let(:success_handler_block_value) { "success handler block value" }
                let(:failure_handler_block_value) { "failure handler block value" }

                context "when NONE of those handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { success_handler_block_value }
                        status.failure { failure_handler_block_value }
                      end
                    end

                    it "returns `nil`" do
                      expect(result.respond_to(&block)).to be_nil
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { success_handler_block_value }
                        status.failure { failure_handler_block_value }
                        status.unexpected { unexpected_handler_block_value }
                      end
                    end

                    it "returns `unexpected` handler block value" do
                      expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                    end
                  end
                end

                context "when that `success` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(foo: :bar)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                      end
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when that `failure` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure("foo")
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { evaluation_tracker.raise "`success` handler" }
                        status.failure(message: "foo") { failure_handler_block_value }
                      end
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { evaluation_tracker.raise "`success` handler" }
                        status.failure(message: "foo") { failure_handler_block_value }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end

              context "when second of those handlers is `error` handler" do
                let(:success_handler_block_value) { "success handler block value" }
                let(:error_handler_block_value) { "error handler block value" }

                context "when NONE of those handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { success_handler_block_value }
                        status.error { error_handler_block_value }
                      end
                    end

                    it "returns `nil`" do
                      expect(result.respond_to(&block)).to be_nil
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { success_handler_block_value }
                        status.error { error_handler_block_value }
                        status.unexpected { unexpected_handler_block_value }
                      end
                    end

                    it "returns `unexpected` handler block value" do
                      expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                    end
                  end
                end

                context "when that `success` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(foo: :bar)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                        status.error { evaluation_tracker.raise "`error` handler" }
                      end
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                        status.error { evaluation_tracker.raise "`failure` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when that `error` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error(code: :foo)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { evaluation_tracker.raise "`success` handler" }
                        status.error(code: :foo) { error_handler_block_value }
                      end
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.success { evaluation_tracker.raise "`success` handler" }
                        status.error(code: :foo) { error_handler_block_value }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end
            end

            context "when first of those handlers is `failure` handler" do
              context "when second of those handlers is `success` handler" do
                let(:failure_handler_block_value) { "failure handler block value" }
                let(:success_handler_block_value) { "success handler block value" }

                context "when NONE of those handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { failure_handler_block_value }
                        status.success { success_handler_block_value }
                      end
                    end

                    it "returns `nil`" do
                      expect(result.respond_to(&block)).to be_nil
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { failure_handler_block_value }
                        status.success { success_handler_block_value }
                        status.unexpected { unexpected_handler_block_value }
                      end
                    end

                    it "returns `unexpected` handler block value" do
                      expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                    end
                  end
                end

                context "when that `failure` handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure("foo")
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure(message: "foo") { failure_handler_block_value }
                        status.success { evaluation_tracker.raise "`success` handler" }
                      end
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure(message: "foo") { failure_handler_block_value }
                        status.success { evaluation_tracker.raise "`success` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when that `success` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(foo: :bar)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                      end
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end

              context "when second of those handlers is `error` handler" do
                let(:failure_handler_block_value) { "failure handler block value" }
                let(:error_handler_block_value) { "error handler block value" }

                context "when NONE of those handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { failure_handler_block_value }
                        status.error { error_handler_block_value }
                      end
                    end

                    it "returns `nil`" do
                      expect(result.respond_to(&block)).to be_nil
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { failure_handler_block_value }
                        status.error { error_handler_block_value }
                        status.unexpected { unexpected_handler_block_value }
                      end
                    end

                    it "returns `unexpected` handler block value" do
                      expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                    end
                  end
                end

                context "when that `failure` handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure("foo")
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure(message: "foo") { failure_handler_block_value }
                        status.error { evaluation_tracker.raise "`error` handler" }
                      end
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure(message: "foo") { failure_handler_block_value }
                        status.error { evaluation_tracker.raise "`error` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when that `error` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error(code: :foo)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                        status.error(code: :foo) { error_handler_block_value }
                      end
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                        status.error(code: :foo) { error_handler_block_value }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end
            end

            context "when first of those handlers is `error` handler" do
              context "when second of those handlers is `success` handler" do
                let(:error_handler_block_value) { "error handler block value" }
                let(:success_handler_block_value) { "success handler block value" }

                context "when NONE of those handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { error_handler_block_value }
                        status.success { success_handler_block_value }
                      end
                    end

                    it "returns `nil`" do
                      expect(result.respond_to(&block)).to be_nil
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { error_handler_block_value }
                        status.success { success_handler_block_value }
                        status.unexpected { unexpected_handler_block_value }
                      end
                    end

                    it "returns `unexpected` handler block value" do
                      expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                    end
                  end
                end

                context "when that `error` handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error(code: :foo)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error(code: :foo) { error_handler_block_value }
                        status.success { evaluation_tracker.raise "`success` handler" }
                      end
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error(code: :foo) { error_handler_block_value }
                        status.success { evaluation_tracker.raise "`success` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end

                    it "does NOT evaluate `success` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`success` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when that `success` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success(foo: :bar)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { evaluation_tracker.raise "`error` handler" }
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                      end
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { evaluation_tracker.raise "`error` handler" }
                        status.success(data: {foo: :bar}) { success_handler_block_value }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end

                    it "returns that matched `success` handler block value" do
                      expect(result.respond_to(&block)).to eq(success_handler_block_value)
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end

              context "when second of those handlers is `failure` handler" do
                let(:error_handler_block_value) { "error handler block value" }
                let(:failure_handler_block_value) { "failure handler block value" }

                context "when NONE of those handlers is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        success
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { error_handler_block_value }
                        status.failure { failure_handler_block_value }
                      end
                    end

                    it "returns `nil`" do
                      expect(result.respond_to(&block)).to be_nil
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { error_handler_block_value }
                        status.failure { failure_handler_block_value }
                        status.unexpected { unexpected_handler_block_value }
                      end
                    end

                    it "returns `unexpected` handler block value" do
                      expect(result.respond_to(&block)).to eq(unexpected_handler_block_value)
                    end
                  end
                end

                context "when that `error` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        error(code: :foo)
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error(code: :foo) { error_handler_block_value }
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                      end
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error(code: :foo) { error_handler_block_value }
                        status.failure { evaluation_tracker.raise "`failure` handler" }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "returns that matched `error` handler block value" do
                      expect(result.respond_to(&block)).to eq(error_handler_block_value)
                    end

                    it "does NOT evaluate `failure` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`failure` handler")
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end

                context "when that `failure` handler is matched" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      def result
                        failure("foo")
                      end
                    end
                  end

                  context "when `collector` does NOT have `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { evaluation_tracker.raise "`error` handler" }
                        status.failure(message: "foo") { failure_handler_block_value }
                      end
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end
                  end

                  context "when `collector` has `unexpected` handler" do
                    let(:block) do
                      proc do |status|
                        status.error { evaluation_tracker.raise "`error` handler" }
                        status.failure(message: "foo") { failure_handler_block_value }
                        status.unexpected { evaluation_tracker.raise "unexpected handler" }
                      end
                    end

                    it "does NOT evaluate `error` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("`error` handler")
                    end

                    it "returns that matched `failure` handler block value" do
                      expect(result.respond_to(&block)).to eq(failure_handler_block_value)
                    end

                    it "does NOT evaluate `unexpected` handler" do
                      result.respond_to(&block)

                      expect(evaluation_tracker).not_to have_received(:raise).with("unexpected handler")
                    end
                  end
                end
              end
            end
          end
        end

        example_group "matched handler" do
          example_group "matched handler `status` kwarg" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            let(:block) do
              proc do |status|
                status.success { |arguments| arguments[:status] }
              end
            end

            it "passes casted `status` as `status` kwarg" do
              expect(result.respond_to(&block)).to eq(result.create_status(:success))
            end
          end

          example_group "matched handler `data` kwarg" do
            context "when `data` is NOT passed to handler" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success
                  end
                end
              end

              let(:block) do
                proc do |status|
                  status.success { |arguments| arguments[:data] }
                end
              end

              it "passes `nil` as `data` kwarg" do
                expect(result.respond_to(&block)).to be_nil
              end
            end

            context "when `data` is passed to handler" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(foo: :bar)
                  end
                end
              end

              context "when `data` can NOT casted" do
                let(:block) do
                  proc do |status|
                    status.success(data: 42) { |arguments| arguments[:data] }
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Failed to cast `42` into `#{result.class.data_class}`.
                  TEXT
                end

                it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
                  expect { result.respond_to(&block) }
                    .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Support::Castable::Exceptions::FailedToCast) { result.respond_to(&block) } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when `data` can casted" do
                let(:block) do
                  proc do |status|
                    status.success(data: {foo: :bar}) { |arguments| arguments[:data] }
                  end
                end

                it "passes casted `data` as `data` kwarg" do
                  expect(result.respond_to(&block)).to eq(result.create_data(foo: :bar))
                end
              end
            end
          end

          example_group "matched handler `message` kwarg" do
            context "when `message` is NOT passed to handler" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    failure
                  end
                end
              end

              let(:block) do
                proc do |status|
                  status.failure { |arguments| arguments[:message] }
                end
              end

              it "passes `nil` as `message` kwarg" do
                expect(result.respond_to(&block)).to be_nil
              end
            end

            context "when `message` is passed to handler" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    failure("foo")
                  end
                end
              end

              context "when `message` can NOT casted" do
                let(:block) do
                  proc do |status|
                    status.failure(message: 42) { |arguments| arguments[:message] }
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Failed to cast `42` into `#{result.class.message_class}`.
                  TEXT
                end

                it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
                  expect { result.respond_to(&block) }
                    .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Support::Castable::Exceptions::FailedToCast) { result.respond_to(&block) } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when `message` can casted" do
                let(:block) do
                  proc do |status|
                    status.failure(message: "foo") { |arguments| arguments[:message] }
                  end
                end

                it "passes casted `message` as `message` kwarg" do
                  expect(result.respond_to(&block)).to eq(result.create_message("foo"))
                end
              end
            end
          end

          example_group "matched handler `code` kwarg" do
            context "when `code` is NOT passed to handler" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    error
                  end
                end
              end

              let(:block) do
                proc do |status|
                  status.error { |arguments| arguments[:code] }
                end
              end

              it "passes `nil` as `code` kwarg" do
                expect(result.respond_to(&block)).to be_nil
              end
            end

            context "when `code` is passed to handler" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    error(code: :foo)
                  end
                end
              end

              context "when `code` can NOT casted" do
                let(:block) do
                  proc do |status|
                    status.error(code: 42) { |arguments| arguments[:code] }
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Failed to cast `42` into `#{result.class.code_class}`.
                  TEXT
                end

                it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
                  expect { result.respond_to(&block) }
                    .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Support::Castable::Exceptions::FailedToCast) { result.respond_to(&block) } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when `code` can casted" do
                let(:block) do
                  proc do |status|
                    status.error(code: :foo) { |arguments| arguments[:code] }
                  end
                end

                it "passes casted `code` as `code` kwarg" do
                  expect(result.respond_to(&block)).to eq(result.create_code(:foo))
                end
              end
            end
          end
        end

        example_group "`unexpected` handler" do
          let(:block) do
            proc do |status|
              status.unexpected {}
            end
          end

          example_group "`unexpected` handler `status` kwarg" do
            let(:block) do
              proc do |status|
                status.unexpected { |arguments| arguments[:status] }
              end
            end

            it "passes `nil` as `status` kwarg" do
              expect(result.respond_to(&block)).to be_nil
            end
          end

          example_group "`unexpected` handler `data` kwarg" do
            let(:block) do
              proc do |status|
                status.unexpected { |arguments| arguments[:data] }
              end
            end

            it "passes `nil` as `data` kwarg" do
              expect(result.respond_to(&block)).to be_nil
            end
          end

          example_group "`unexpected` handler `message` kwarg" do
            let(:block) do
              proc do |status|
                status.unexpected { |arguments| arguments[:message] }
              end
            end

            it "passes `nil` as `message` kwarg" do
              expect(result.respond_to(&block)).to be_nil
            end
          end

          example_group "`unexpected` handler `code` kwarg" do
            let(:block) do
              proc do |status|
                status.unexpected { |arguments| arguments[:code] }
              end
            end

            it "passes `nil` as `code` kwarg" do
              expect(result.respond_to(&block)).to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
