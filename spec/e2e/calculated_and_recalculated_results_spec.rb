# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Calculated and recalculated results", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  example_group "Service" do
    example_group "instance methods" do
      # rubocop:disable RSpec/MultipleExpectations
      describe "#recalculate" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end

            def negated_result
              success
            end

            def fallback_failure_result
              success
            end

            def fallback_error_result
              success
            end

            def fallback_result
              success
            end
          end
        end

        let(:service) { service_class.new }

        context "when used with `result`" do
          it "recalculates that `result`" do
            expect(service.result).to equal(service.result)
            expect(service.result).to eq(service.result)

            expect(service.result).not_to equal(service.recalculate.result)
            expect(service.result).to eq(service.recalculate.result)
          end
        end

        context "when used with `negated_result`" do
          it "recalculates that `negated_result`" do
            expect(service.negated_result).to equal(service.negated_result)
            expect(service.negated_result).to eq(service.negated_result)

            expect(service.negated_result).not_to equal(service.recalculate.negated_result)
            expect(service.negated_result).to eq(service.recalculate.negated_result)
          end
        end

        context "when used with `fallback_failure_result`" do
          it "recalculates that `fallback_failure_result`" do
            expect(service.fallback_failure_result).to equal(service.fallback_failure_result)
            expect(service.fallback_failure_result).to eq(service.fallback_failure_result)

            expect(service.fallback_failure_result).not_to equal(service.recalculate.fallback_failure_result)
            expect(service.fallback_failure_result).to eq(service.recalculate.fallback_failure_result)
          end
        end

        context "when used with `fallback_error_result`" do
          it "recalculates that `fallback_error_result`" do
            expect(service.fallback_error_result).to equal(service.fallback_error_result)
            expect(service.fallback_error_result).to eq(service.fallback_error_result)

            expect(service.fallback_error_result).not_to equal(service.recalculate.fallback_error_result)
            expect(service.fallback_error_result).to eq(service.recalculate.fallback_error_result)
          end
        end

        context "when used with `fallback_result`" do
          it "recalculates that `fallback_result`" do
            expect(service.fallback_result).to equal(service.fallback_result)
            expect(service.fallback_result).to eq(service.fallback_result)

            expect(service.fallback_result).not_to equal(service.recalculate.fallback_result)
            expect(service.fallback_result).to eq(service.recalculate.fallback_result)
          end
        end
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
