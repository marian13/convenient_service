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
