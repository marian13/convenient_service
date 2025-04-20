# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Services with custom negated results", type: [:standard, :e2e] do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  example_group "Service" do
    example_group "instance methods" do
      describe "#negated_result" do
        let(:service) { service_class.new }

        context "when service has custom `negated_result` that returns NOT valid result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                42
              end
            end
          end

          it "raises `ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult`" do
            expect { service.negated_result }
              .to raise_error(ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult)
          end
        end

        context "when service has custom `negated_result` that returns valid result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                success
              end
            end
          end

          it "returns negated result" do
            expect(service.negated_result.negated?).to eq(true)
          end
        end

        context "when service has custom `negated_result` that raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                raise ArgumentError
              end
            end
          end

          let(:service) { service_class.new }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to that exception" do
            expect { service.negated_result }
              .to raise_error(ArgumentError) do |exception|
                expect(exception.services).to eq([{instance: service, trigger: {method: ":negated_result"}}])
              end
          end
          # rubocop:enable RSpec/MultipleExpectations

          context "when service uses `fault_tolerance` config option" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config.with(:fault_tolerance)

                def negated_result
                  raise ArgumentError
                end
              end
            end

            it "adds service details to that exception" do
              expect(service.negated_result.from_unhandled_exception?).to eq(true)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
