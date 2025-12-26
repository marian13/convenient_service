# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  include ConvenientService::RSpec::Helpers::IgnoringException

  let(:result_mock) { described_class.new(status: status, service_class: service_class, arguments: arguments, chain: chain) }

  let(:status) { :success }
  let(:chain) { {} }

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }

  let(:data) { {foo: :bar} }
  let(:message) { "foo" }
  let(:code) { :foo }

  let(:result) { result_mock.result }

  example_group "class methods" do
    describe ".new" do
      context "when service class is NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(status: status, arguments: arguments, chain: chain)).to eq(described_class.new(status: status, service_class: nil, arguments: arguments, chain: chain))
        end
      end

      context "when arguments are NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(status: status, service_class: service_class, chain: chain)).to eq(described_class.new(status: status, service_class: service_class, arguments: nil, chain: chain))
        end
      end

      context "when chain is NOT passed" do
        it "defaults to empty hash" do
          expect(described_class.new(status: status, service_class: service_class, arguments: arguments)).to eq(described_class.new(status: status, service_class: service_class, arguments: arguments, chain: {}))
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#for" do
      let(:other_service_class) { Class.new }
      let(:other_arguments) { ConvenientService::Support::Arguments.new(:bar, {bar: :baz}) { :bar } }

      it "returns result mock copy with passed service class and arguments" do
        expect(result_mock.for(other_service_class, other_arguments)).to eq(described_class.new(status: status, service_class: other_service_class, arguments: other_arguments, chain: chain))
      end
    end

    describe "#register" do
      context "when `block` is NOT passed" do
        specify do
          expect { result_mock.register }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, :call)
              .with_arguments(service: service_class, arguments: arguments, result: result)
              .and_return { result_mock }
        end

        specify do
          expect { result_mock.register }
            .not_to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_any_arguments
        end
      end

      context "when `block` is passed" do
        let(:block) { proc { :foo } }

        specify do
          expect { result_mock.register(&block) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, :call)
              .with_arguments(service: service_class, arguments: arguments, result: result)
              .and_return { block.call }
        end

        specify do
          expect { result_mock.register(&block) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: arguments)
        end

        context "when `block` raises exception" do
          let(:block) { proc { 16 / 0 } }

          specify do
            expect { ignoring_exception(ZeroDivisionError) { result_mock.register(&block) } }
              .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
              .with_arguments(service: service_class, arguments: arguments)
          end
        end
      end
    end

    describe "#unregister" do
      specify do
        expect { result_mock.unregister }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::DeleteServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: arguments)
            .and_return { result_mock }
      end
    end

    describe "#result" do
      context "when result mock for failure" do
        let(:result_mock) { described_class.new(status: :failure, service_class: service_class, arguments: arguments) }

        it "returns failure" do
          expect(result_mock.result).to be_failure
        end

        it "returns stubbed result" do
          expect(result_mock.result.stubbed_result?).to be(true)
        end

        context "when result mock for failure with data" do
          let(:result_mock) { described_class.new(status: :failure, service_class: service_class, arguments: arguments).with_data(data) }
          let(:data) { {foo: :bar} }

          it "returns failure with data" do
            expect(result_mock.result).to be_failure.with_data(data)
          end
        end
      end

      context "when result mock for error" do
        let(:result_mock) { described_class.new(status: :error, service_class: service_class, arguments: arguments) }

        it "returns `error`" do
          expect(result_mock.result).to be_error
        end

        it "returns stubbed result" do
          expect(result_mock.result.stubbed_result?).to be(true)
        end

        context "when result mock for error with message" do
          let(:result_mock) { described_class.new(status: :error, service_class: service_class, arguments: arguments).with_message(message) }
          let(:message) { "foo" }

          it "returns `error` with message" do
            expect(result_mock.result).to be_error.with_message(message)
          end

          context "when result mock for error with message and code" do
            let(:result_mock) { described_class.new(status: :error, service_class: service_class, arguments: arguments).with_message(message).and_code(code) }
            let(:code) { :foo }

            it "returns `error` with message" do
              expect(result_mock.result).to be_error.with_message(message).and_code(code)
            end
          end
        end

        context "when result mock for error with code" do
          let(:result_mock) { described_class.new(status: :error, service_class: service_class, arguments: arguments).with_code(code) }
          let(:code) { :foo }

          it "returns `error` with code" do
            expect(result_mock.result).to be_error.with_code(code)
          end

          context "when result mock for error with code and message" do
            let(:result_mock) { described_class.new(status: :error, service_class: service_class, arguments: arguments).with_code(code).and_message(message) }
            let(:message) { "foo" }

            it "returns `error` with message" do
              expect(result_mock.result).to be_error.with_code(code).and_message(message)
            end
          end
        end
      end

      context "when result mock for success" do
        let(:result_mock) { described_class.new(status: :success, service_class: service_class, arguments: arguments) }

        it "returns success" do
          expect(result_mock.result).to be_success
        end

        it "returns stubbed result" do
          expect(result_mock.result.stubbed_result?).to be(true)
        end

        context "when result mock for success with data" do
          let(:result_mock) { described_class.new(status: :success, service_class: service_class, arguments: arguments).with_data(data) }
          let(:data) { {foo: :bar} }

          it "returns success with data" do
            expect(result_mock.result).to be_success.with_data(data)
          end
        end
      end
    end

    describe "#with_data" do
      it "sets chain `data`" do
        expect { result_mock.with_data(data) }.to change { result_mock.result.unsafe_data.to_h }.from({}).to(data)
      end

      it "returns result mock" do
        expect(result_mock.with_data(data)).to eq(result_mock)
      end
    end

    describe "#with_message" do
      it "sets chain `message`" do
        expect { result_mock.with_message(message) }.to change { result_mock.result.unsafe_message.to_s }.from("").to(message)
      end

      it "returns result mock" do
        expect(result_mock.with_message(message)).to eq(result_mock)
      end
    end

    describe "#with_code" do
      it "sets chain `code`" do
        expect { result_mock.with_code(code) }.to change { result_mock.result.unsafe_code.to_sym }.from(:default_success).to(code)
      end

      it "returns result mock" do
        expect(result_mock.with_code(code)).to eq(result_mock)
      end
    end

    describe "#and_data" do
      it "sets chain `data`" do
        expect { result_mock.and_data(data) }.to change { result_mock.result.unsafe_data.to_h }.from({}).to(data)
      end

      it "returns result mock" do
        expect(result_mock.and_data(data)).to eq(result_mock)
      end
    end

    describe "#and_message" do
      it "sets chain `message`" do
        expect { result_mock.and_message(message) }.to change { result_mock.result.unsafe_message.to_s }.from("").to(message)
      end

      it "returns result mock" do
        expect(result_mock.and_message(message)).to eq(result_mock)
      end
    end

    describe "#and_code" do
      it "sets chain `code`" do
        expect { result_mock.and_code(code) }.to change { result_mock.result.unsafe_code.to_sym }.from(:default_success).to(code)
      end

      it "returns result mock" do
        expect(result_mock.and_code(code)).to eq(result_mock)
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(result_mock == other).to be_nil
          end
        end

        context "when `other` has different `status`" do
          let(:other) { described_class.new(status: :error, service_class: service_class, arguments: arguments, chain: chain) }

          it "returns `false`" do
            expect(result_mock == other).to be(false)
          end
        end

        context "when `other` has different `service_class`" do
          let(:other) { described_class.new(status: status, service_class: Class.new, arguments: arguments, chain: chain) }

          it "returns `false`" do
            expect(result_mock == other).to be(false)
          end
        end

        context "when `other` has different `arguments`" do
          let(:other) { described_class.new(status: status, service_class: service_class, arguments: ConvenientService::Support::Arguments.null_arguments, chain: chain) }

          it "returns `false`" do
            expect(result_mock == other).to be(false)
          end
        end

        context "when `other` has different `chain`" do
          let(:other) { described_class.new(status: status, service_class: service_class, arguments: arguments, chain: {args: [:bar], kwargs: {bar: :foo}, block: -> { :bar }}) }

          it "returns `false`" do
            expect(result_mock == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(status: status, service_class: service_class, arguments: arguments, chain: chain) }

          it "returns `true`" do
            expect(result_mock == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
