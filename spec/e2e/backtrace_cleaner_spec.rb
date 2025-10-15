# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Backtrace cleaner", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "instance methods" do
      describe "#initialize" do
        context "when `#initialize` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize
                raise ZeroDivisionError, "exception from `#initialize`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.new }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#initialize`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#initialize` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize
                raise ZeroDivisionError, "exception from `#initialize`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#initialize`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.new }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#initialize`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#result" do
        context "when `#result` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception from `#result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#result`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#result` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception from `#result`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#result`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#negated_result" do
        context "when `#negated_result` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                raise ZeroDivisionError, "exception from `#negated_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.negated_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#negated_result`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#negated_result` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                raise ZeroDivisionError, "exception from `#negated_result`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#negated_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.negated_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#negated_result`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#fallback_failure_result" do
        context "when `#fallback_failure_result` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_failure_result
                raise ZeroDivisionError, "exception from `#fallback_failure_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.fallback_failure_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#fallback_failure_result`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#fallback_failure_result` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_failure_result
                raise ZeroDivisionError, "exception from `#fallback_failure_result`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#fallback_failure_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.fallback_failure_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#fallback_failure_result`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#fallback_error_result" do
        context "when `#fallback_error_result` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_error_result
                raise ZeroDivisionError, "exception from `#fallback_error_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.fallback_error_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#fallback_error_result`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#fallback_error_result` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_error_result
                raise ZeroDivisionError, "exception from `#fallback_error_result`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#fallback_error_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.fallback_error_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#fallback_error_result`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#fallback_result" do
        context "when `#fallback_result` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_result
                raise ZeroDivisionError, "exception from `#fallback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.fallback_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#fallback_result`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#fallback_result` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_result
                raise ZeroDivisionError, "exception from `#fallback_result`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#fallback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.fallback_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#fallback_result`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#rollback_result" do
        context "when `#rollback_result` raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def rollback_result
                raise ZeroDivisionError, "exception from `#rollback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.new.rollback_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#rollback_result`")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#rollback_result` reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def rollback_result
                raise ZeroDivisionError, "exception from `#rollback_result`"
              rescue
                raise ZeroDivisionError, "reraised exception from `#rollback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.new.rollback_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#rollback_result`")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "service step" do
        context "when service step raises exception" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(service_step) do |service_step|
                include ConvenientService::Standard::Config

                step service_step
              end
            end
          end

          let(:service_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception from service step"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from service step")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when service step reraises exception" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(service_step) do |service_step|
                include ConvenientService::Standard::Config

                step service_step
              end
            end
          end

          let(:service_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception from service step"
              rescue
                raise ZeroDivisionError, "reraised exception from service step"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception cause backtrace" do
            expect { service.result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from service step")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "method step" do
        context "when method step raises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :method_step

              def method_step
                raise ZeroDivisionError, "exception from method step"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from method step")
              expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when method step reraises exception" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              step :method_step

              def method_step
                raise ZeroDivisionError, "exception from method step"
              rescue
                raise ZeroDivisionError, "reraised exception from service step"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans that exception backtrace" do
            expect { service.result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from method step")
              expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
