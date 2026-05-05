# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    specify do
      expect(described_class.success_status).to equal(described_class::Constants::SUCCESS_STATUS)
    end

    specify do
      expect(described_class.failure_status).to equal(described_class::Constants::FAILURE_STATUS)
    end

    specify do
      expect(described_class.error_status).to equal(described_class::Constants::ERROR_STATUS)
    end

    specify do
      expect(described_class.default_success_data).to equal(described_class::Constants::DEFAULT_SUCCESS_DATA)
    end

    specify do
      expect(described_class.default_failure_data).to equal(described_class::Constants::DEFAULT_FAILURE_DATA)
    end

    specify do
      expect(described_class.default_error_data).to equal(described_class::Constants::DEFAULT_ERROR_DATA)
    end

    specify do
      expect(described_class.default_success_message).to equal(described_class::Constants::DEFAULT_SUCCESS_MESSAGE)
    end

    specify do
      expect(described_class.default_failure_message).to equal(described_class::Constants::DEFAULT_FAILURE_MESSAGE)
    end

    specify do
      expect(described_class.default_error_message).to equal(described_class::Constants::DEFAULT_ERROR_MESSAGE)
    end

    specify do
      expect(described_class.default_success_code).to equal(described_class::Constants::DEFAULT_SUCCESS_CODE)
    end

    specify do
      expect(described_class.default_failure_code).to equal(described_class::Constants::DEFAULT_FAILURE_CODE)
    end

    specify do
      expect(described_class.default_error_code).to equal(described_class::Constants::DEFAULT_ERROR_CODE)
    end

    describe ".default_success_data?" do
      context "when `other` is NOT default success data" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_success_data?(other)).to be(false)
        end
      end

      context "when `other` is default success data" do
        let(:other) { described_class.default_success_data }

        it "return `true`" do
          expect(described_class.default_success_data?(other)).to be(true)
        end
      end
    end

    describe ".default_failure_data?" do
      context "when `other` is NOT default failure data" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_failure_data?(other)).to be(false)
        end
      end

      context "when `other` is default failure data" do
        let(:other) { described_class.default_failure_data }

        it "return `true`" do
          expect(described_class.default_failure_data?(other)).to be(true)
        end
      end
    end

    describe ".default_error_data?" do
      context "when `other` is NOT default error data" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_error_data?(other)).to be(false)
        end
      end

      context "when `other` is default error data" do
        let(:other) { described_class.default_error_data }

        it "return `true`" do
          expect(described_class.default_error_data?(other)).to be(true)
        end
      end
    end

    describe ".default_success_message?" do
      context "when `other` is NOT default success message" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_success_message?(other)).to be(false)
        end
      end

      context "when `other` is default success message" do
        let(:other) { described_class.default_success_message }

        it "return `true`" do
          expect(described_class.default_success_message?(other)).to be(true)
        end
      end
    end

    describe ".default_failure_message?" do
      context "when `other` is NOT default failure message" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_failure_message?(other)).to be(false)
        end
      end

      context "when `other` is default failure message" do
        let(:other) { described_class.default_failure_message }

        it "return `true`" do
          expect(described_class.default_failure_message?(other)).to be(true)
        end
      end
    end

    describe ".default_error_message?" do
      context "when `other` is NOT default error message" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_error_message?(other)).to be(false)
        end
      end

      context "when `other` is default error message" do
        let(:other) { described_class.default_error_message }

        it "return `true`" do
          expect(described_class.default_error_message?(other)).to be(true)
        end
      end
    end

    describe ".default_success_code?" do
      context "when `other` is NOT default success code" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_success_code?(other)).to be(false)
        end
      end

      context "when `other` is default success code" do
        let(:other) { described_class.default_success_code }

        it "return `true`" do
          expect(described_class.default_success_code?(other)).to be(true)
        end
      end
    end

    describe ".default_failure_code?" do
      context "when `other` is NOT default failure code" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_failure_code?(other)).to be(false)
        end
      end

      context "when `other` is default failure code" do
        let(:other) { described_class.default_failure_code }

        it "return `true`" do
          expect(described_class.default_failure_code?(other)).to be(true)
        end
      end
    end

    describe ".default_error_code?" do
      context "when `other` is NOT default error code" do
        let(:other) { 42 }

        it "return `false`" do
          expect(described_class.default_error_code?(other)).to be(false)
        end
      end

      context "when `other` is default error code" do
        let(:other) { described_class.default_error_code }

        it "return `true`" do
          expect(described_class.default_error_code?(other)).to be(true)
        end
      end
    end

    describe ".result_class?" do
      context "when `result` is NOT class" do
        let(:result_class) { 42 }

        it "returns `false`" do
          expect(described_class.result_class?(result_class)).to be(false)
        end
      end

      context "when `result` is class" do
        context "when `result` is NOT result class" do
          let(:result_class) { Class.new }

          it "returns `false`" do
            expect(described_class.result_class?(result_class)).to be(false)
          end

          context "when `result` is entity class" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(described_class.result_class?(service_class)).to be(false)
            end
          end
        end

        context "when `result` is result class" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:result_class) { service_class.new.result.class }

          it "returns `true`" do
            expect(described_class.result_class?(result_class)).to be(true)
          end
        end
      end
    end

    describe ".result?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:result_class) { service_class.result_class }
      let(:result_instance) { service_class.result }

      specify do
        expect { described_class.result?(result_instance) }
          .to delegate_to(described_class, :result_class?)
          .with_arguments(result_class)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
