# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:handler) { described_class.new(result: result, status: status, data: data, message: message, code: code, block: block) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:result) { service.result }

  let(:status) { :success }
  let(:data) { {foo: :bar} }
  let(:message) { "foo" }
  let(:code) { :foo }
  let(:block) { proc { block_value } }
  let(:block_value) { "block value" }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { handler }

      it { is_expected.to have_attr_reader(:result) }
      it { is_expected.to have_attr_reader(:status) }
      it { is_expected.to have_attr_reader(:data) }
      it { is_expected.to have_attr_reader(:message) }
      it { is_expected.to have_attr_reader(:code) }
      it { is_expected.to have_attr_reader(:block) }
    end

    describe "#casted_status" do
      specify do
        expect { handler.casted_status }
          .to delegate_to(result, :create_status)
          .with_arguments(status)
          .and_return_its_value
      end

      specify do
        expect { handler.casted_status }.to cache_its_value
      end
    end

    describe "#casted_data" do
      specify do
        expect { handler.casted_data }
          .to delegate_to(result, :create_data)
          .with_arguments(data)
          .and_return_its_value
      end

      specify do
        expect { handler.casted_data }.to cache_its_value
      end
    end

    describe "#casted_message" do
      specify do
        expect { handler.casted_message }
          .to delegate_to(result, :create_message)
          .with_arguments(message)
          .and_return_its_value
      end

      specify do
        expect { handler.casted_message }.to cache_its_value
      end
    end

    describe "#casted_code" do
      specify do
        expect { handler.casted_code }
          .to delegate_to(result, :create_code)
          .with_arguments(code)
          .and_return_its_value
      end

      specify do
        expect { handler.casted_code }.to cache_its_value
      end
    end

    describe "#matches?" do
      let(:data) { nil }
      let(:message) { nil }
      let(:code) { nil }

      context "when casted status is NOT equal to result status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end
          end
        end

        specify do
          expect { handler.matches? }
            .to delegate_to(handler.casted_status, :===)
            .with_arguments(result.status)
        end

        it "returns `false`" do
          expect(handler.matches?).to eq(false)
        end
      end

      context "when casted status is equal to result status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        specify do
          expect { handler.matches? }
            .to delegate_to(handler.casted_status, :===)
            .with_arguments(result.status)
        end

        specify do
          expect { handler.matches? }.not_to delegate_to(result, :create_data)
        end

        specify do
          expect { handler.matches? }.not_to delegate_to(result, :create_message)
        end

        specify do
          expect { handler.matches? }.not_to delegate_to(result, :create_code)
        end

        it "returns `true`" do
          expect(handler.matches?).to eq(true)
        end

        context "when `data` is passed" do
          let(:data) { {foo: :bar} }

          context "when casted data is NOT equal to result data" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(baz: :qux)
                end
              end
            end

            specify do
              expect { handler.matches? }
                .to delegate_to(handler.casted_data, :===)
                .with_arguments(result.unsafe_data)
            end

            it "returns `false`" do
              expect(handler.matches?).to eq(false)
            end
          end

          context "when casted data is equal to result data" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(foo: :bar)
                end
              end
            end

            specify do
              expect { handler.matches? }
                .to delegate_to(handler.casted_data, :===)
                .with_arguments(result.unsafe_data)
            end

            it "returns `true`" do
              expect(handler.matches?).to eq(true)
            end
          end
        end

        context "when `message` is passed" do
          let(:message) { "foo" }

          context "when casted message is NOT equal to result message" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(message: "bar")
                end
              end
            end

            specify do
              expect { handler.matches? }
                .to delegate_to(handler.casted_message, :===)
                .with_arguments(result.unsafe_message)
            end

            it "returns `false`" do
              expect(handler.matches?).to eq(false)
            end
          end

          context "when casted message is equal to result message" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(message: "foo")
                end
              end
            end

            specify do
              expect { handler.matches? }
                .to delegate_to(handler.casted_message, :===)
                .with_arguments(result.unsafe_message)
            end

            it "returns `true`" do
              expect(handler.matches?).to eq(true)
            end
          end
        end

        context "when `code` is passed" do
          let(:code) { :foo }

          context "when casted code is NOT equal to result code" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(code: :bar)
                end
              end
            end

            specify do
              expect { handler.matches? }
                .to delegate_to(handler.casted_code, :===)
                .with_arguments(result.unsafe_code)
            end

            it "returns `false`" do
              expect(handler.matches?).to eq(false)
            end
          end

          context "when casted code is equal to result code" do
            let(:service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success(code: :foo)
                end
              end
            end

            specify do
              expect { handler.matches? }
                .to delegate_to(handler.casted_code, :===)
                .with_arguments(result.unsafe_code)
            end

            it "returns `true`" do
              expect(handler.matches?).to eq(true)
            end
          end
        end
      end
    end

    describe "#handle" do
      let(:data) { nil }
      let(:message) { nil }
      let(:code) { nil }

      specify do
        expect { handler.handle }
          .to delegate_to(block, :call)
          .with_arguments(ConvenientService::Support::Arguments.new(status: handler.casted_status, data: nil, message: nil, code: nil))
          .and_return_its_value
      end

      context "when `data` is passed" do
        let(:data) { {foo: :bar} }

        specify do
          expect { handler.handle }
            .to delegate_to(block, :call)
            .with_arguments(ConvenientService::Support::Arguments.new(status: handler.casted_status, data: handler.casted_data, message: nil, code: nil))
            .and_return_its_value
        end
      end

      context "when `message` is passed" do
        let(:message) { "foo" }

        specify do
          expect { handler.handle }
            .to delegate_to(block, :call)
            .with_arguments(ConvenientService::Support::Arguments.new(status: handler.casted_status, data: nil, message: handler.casted_message, code: nil))
            .and_return_its_value
        end
      end

      context "when `code` is passed" do
        let(:code) { :foo }

        specify do
          expect { handler.handle }
            .to delegate_to(block, :call)
            .with_arguments(ConvenientService::Support::Arguments.new(status: handler.casted_status, data: nil, message: nil, code: handler.casted_code))
            .and_return_its_value
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:handler) { described_class.new(result: result, status: status, data: data, message: message, code: code, block: block) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(handler == other).to be_nil
          end
        end

        context "when `other` has different `result`" do
          let(:other) { described_class.new(result: service.failure, status: status, data: data, message: message, code: code, block: block) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has different `status`" do
          let(:other) { described_class.new(result: result, status: :failure, data: data, message: message, code: code, block: block) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has different `data`" do
          let(:other) { described_class.new(result: result, status: status, data: {baz: :qux}, message: message, code: code, block: block) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has different `message`" do
          let(:other) { described_class.new(result: result, status: status, data: data, message: "bar", code: code, block: block) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has different `code`" do
          let(:other) { described_class.new(result: result, status: status, data: data, message: message, code: :bar, block: block) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has different `block`" do
          let(:other) { described_class.new(result: result, status: status, data: data, message: message, code: code, block: proc {}) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(result: result, status: status, data: data, message: message, code: code, block: block) }

          it "returns `true`" do
            expect(handler == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
