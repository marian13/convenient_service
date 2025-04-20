# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Success::Commands::GenerateGotJsendAttributesPart, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      let(:base_matcher) { be_success }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(data: {foo: :bar})
          end
        end
      end

      let(:result) { service.result }

      let(:data) { {foo: :bar} }
      let(:message) { "foo" }
      let(:code) { :foo }

      let(:status_part) { "with `success` status" }
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

            it "returns status and with data parts" do
              expect(command_result).to eq([status_part, data_part].join("\n"))
            end

            context "when result has empty data" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {})
                  end
                end
              end

              let(:data_part) { "with empty data" }

              it "returns status and with empty data parts" do
                expect(command_result).to eq([status_part, data_part].join("\n"))
              end
            end

            context "when result has NOT empty message" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo")
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
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, code: :foo)
                  end
                end
              end

              it "returns status and with data and message and code parts" do
                expect(command_result).to eq([status_part, data_part, code_part].join("\n"))
              end
            end

            context "when result has both NOT empty message and NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo", code: :foo)
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

            it "returns status and with data parts" do
              expect(command_result).to eq([status_part, data_part].join("\n"))
            end

            context "when result has empty data" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {})
                  end
                end
              end

              let(:data_part) { "with empty data" }

              it "returns status and with empty data parts" do
                expect(command_result).to eq([status_part, data_part].join("\n"))
              end
            end

            context "when result has NOT empty message" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo")
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
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, code: :foo)
                  end
                end
              end

              it "returns status and with data and message and code parts" do
                expect(command_result).to eq([status_part, data_part, code_part].join("\n"))
              end
            end

            context "when result has both NOT empty message and NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo", code: :foo)
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
              expect(command_result).to eq([status_part, data_part].join("\n"))
            end

            context "when result has empty data" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {})
                  end
                end
              end

              let(:data_part) { "with empty data" }

              it "returns status and with empty data parts" do
                expect(command_result).to eq([status_part, data_part].join("\n"))
              end
            end

            context "when result has NOT empty message" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo")
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
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, code: :foo)
                  end
                end
              end

              it "returns status and with data and message and code parts" do
                expect(command_result).to eq([status_part, data_part, code_part].join("\n"))
              end
            end

            context "when result has both NOT empty message and NOT default code" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  def result
                    success(data: {foo: :bar}, message: "foo", code: :foo)
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
