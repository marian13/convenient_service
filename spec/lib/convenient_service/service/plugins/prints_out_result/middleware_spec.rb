# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::PrintsOutResult::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Plugins::HasResult::Concern

          def result
            success(data: { test: 'Test' })
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify { expect { method_value }.to call_chain_next.on(method) }

      context 'when services class does NOT have @print_out' do
        let(:output_value) { "{:test=>\"Test\"}" }

        it 'returns original value without printing it' do
          expect { method_value }.to_not output("\e[32;1m#{output_value}\e[0m\n").to_stdout # `[32;1m[0m` means green color

          expect(method_value).to be_success
        end
      end

      context 'when services class have @print_out' do
        let(:output_value) { "{:test=>\"Test\"}" }
        let(:error_message) { 'I am an error' }

        context 'and its value is true' do
          context 'and result is success' do
            let(:service_class) do
              Class.new do
                include ConvenientService::Service::Plugins::HasResult::Concern

                def initialize(print_out: true)
                  @print_out = print_out
                end

                def result
                  success(data: { test: 'Test' })
                end
              end
            end

            it 'prints and returns original value' do
              expect { method_value }.to output("\e[32;1m#{output_value}\e[0m\n").to_stdout # `[32;1m[0m` means green color

              expect(method_value).to be_success
            end
          end

          context 'and result is error' do
            let(:service_class) do
              Class.new do
                include ConvenientService::Service::Plugins::HasResult::Concern

                def initialize(print_out: true)
                  @print_out = print_out
                end

                def result
                  return error(message: 'I am an error') if true

                  success
                end
              end
            end

            it 'prints and returns original value' do
              expect { method_value }.to output("\e[31;1m#{error_message}\e[0m\n").to_stdout # `[31;1m[0m` means red color

              expect(method_value).to be_error
            end
          end
        end

        context 'and its value is false' do
          let(:service_class) do
            Class.new do
              include ConvenientService::Service::Plugins::HasResult::Concern

              def initialize(print_out: false)
                @print_out = print_out
              end

              def result
                success(data: { test: 'Test' })
              end
            end
          end

          it 'returns original value without printing it' do
            expect { method_value }.to_not output("\e[32;1m#{output_value}\e[0m\n").to_stdout # `[32;1m[0m` means green color

            expect(method_value).to be_success
          end
        end

        context 'and its value is NOT boolean' do
          let(:failure_message) { 'test Failure message' }
          let(:service_class) do
            Class.new do
              include ConvenientService::Service::Plugins::HasResult::Concern

              def initialize(data: nil, print_out: nil)
                @data = data
                @print_out = print_out
              end

              def result
                return failure(data: { test: 'Failure message' }) if @data.nil?

                success
              end
            end
          end

          it 'returns original value without printing it' do
            expect { method_value }.to_not output("\e[31;1m#{failure_message}\e[0m\n").to_stdout # `[31;1m[0m` means red color

            expect(method_value).to be_failure
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
