# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Failure::Commands::GenerateGotJsendAttributesPart, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      let(:base_matcher) { be_failure }

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def result
            failure(message: "foo")
          end
        end
      end

      let(:result) { service.result }

      let(:data) { {foo: :bar} }
      let(:message) { "foo" }
      let(:code) { :foo }

      let(:status_part) { "with `failure` status" }
      let(:data_part) { "with data `#{data}`" }
      let(:message_part) { "with message `#{message}`" }
      let(:code_part) { "with code `#{code}`" }

      context "when matcher has NOT result" do
        let(:matcher) { base_matcher }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher has result" do
        context "when none of `with_data`, `with_message` or `with_code` is used" do
          let(:matcher) { base_matcher.tap { |matcher| matcher.matches?(result) } }

          it "returns status part" do
            expect(command_result).to eq(status_part)
          end
        end

        context "when any of `with_data`, `with_message` or `with_code` is used" do
          context "when `with_data` is used" do
            let(:matcher) { base_matcher.with_data(data).tap { |matcher| matcher.matches?(result) } }

            it "returns status and with message parts" do
              expect(command_result).to eq([status_part, message_part].join("\n"))
            end

            context "when result has empty message" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(message: "")
                  end
                end
              end

              let(:message_part) { "with empty message" }

              it "returns status and with empty message parts" do
                expect(command_result).to eq([status_part, message_part].join("\n"))
              end
            end

            context "when result has NOT empty data" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(data: {foo: :bar}, message: "foo")
                  end
                end
              end

              it "returns status and with data and message parts" do
                expect(command_result).to eq([status_part, data_part, message_part].join("\n"))
              end
            end

            context "when result has NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(message: "foo", code: :foo)
                  end
                end
              end

              it "returns status and with message and code parts" do
                expect(command_result).to eq([status_part, message_part, code_part].join("\n"))
              end
            end

            context "when result has both NOT empty data and NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(data: {foo: :bar}, message: "foo", code: :foo)
                  end
                end
              end

              it "returns status and with data and message and code parts" do
                expect(command_result).to eq([status_part, data_part, message_part, code_part].join("\n"))
              end
            end
          end

          context "when `with_message` is used" do
            let(:matcher) { base_matcher.with_message(message).tap { |matcher| matcher.matches?(result) } }

            it "returns status and with message parts" do
              expect(command_result).to eq([status_part, message_part].join("\n"))
            end

            context "when result has empty message" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(message: "")
                  end
                end
              end

              let(:message_part) { "with empty message" }

              it "returns status and with empty message parts" do
                expect(command_result).to eq([status_part, message_part].join("\n"))
              end
            end

            context "when result has NOT empty data" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(data: {foo: :bar}, message: "foo")
                  end
                end
              end

              it "returns status and with data and message parts" do
                expect(command_result).to eq([status_part, data_part, message_part].join("\n"))
              end
            end

            context "when result has NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(message: "foo", code: :foo)
                  end
                end
              end

              it "returns status and with message and code parts" do
                expect(command_result).to eq([status_part, message_part, code_part].join("\n"))
              end
            end

            context "when result has both NOT empty data and NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(data: {foo: :bar}, message: "foo", code: :foo)
                  end
                end
              end

              it "returns status and with data and message and code parts" do
                expect(command_result).to eq([status_part, data_part, message_part, code_part].join("\n"))
              end
            end
          end

          context "when `with_code` is used" do
            let(:matcher) { base_matcher.with_code(code).tap { |matcher| matcher.matches?(result) } }

            it "returns status with message parts" do
              expect(command_result).to eq([status_part, message_part].join("\n"))
            end

            context "when result has empty message" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(message: "")
                  end
                end
              end

              let(:message_part) { "with empty message" }

              it "returns status and with empty message parts" do
                expect(command_result).to eq([status_part, message_part].join("\n"))
              end
            end

            context "when result has NOT empty data" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(data: {foo: :bar}, message: "foo")
                  end
                end
              end

              it "returns status and with data and message parts" do
                expect(command_result).to eq([status_part, data_part, message_part].join("\n"))
              end
            end

            context "when result has NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(message: "foo", code: :foo)
                  end
                end
              end

              it "returns status and with message and code parts" do
                expect(command_result).to eq([status_part, message_part, code_part].join("\n"))
              end
            end

            context "when result has both NOT empty data and NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure(data: {foo: :bar}, message: "foo", code: :foo)
                  end
                end
              end

              it "returns status and with data and message and code parts" do
                expect(command_result).to eq([status_part, data_part, message_part, code_part].join("\n"))
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
