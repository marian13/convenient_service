# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".step_class?" do
      context "when `step` is NOT class" do
        let(:step_class) { 42 }

        it "returns `false`" do
          expect(described_class.step_class?(step_class)).to be(false)
        end
      end

      context "when `step` is class" do
        context "when `step` is NOT step class" do
          let(:step_class) { Class.new }

          it "returns `false`" do
            expect(described_class.step_class?(step_class)).to be(false)
          end

          context "when `step` is entity class" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(described_class.step_class?(service_class)).to be(false)
            end
          end
        end

        context "when `step` is step class" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              step :result

              def result
                success
              end
            end
          end

          let(:step_class) { service_class.new.steps.first.class }

          it "returns `true`" do
            expect(described_class.step_class?(step_class)).to be(true)
          end
        end
      end
    end

    describe ".step?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          step :result

          def result
            success
          end
        end
      end

      let(:step_class) { service_class.step_class }
      let(:step_instance) { service_class.new.steps.first }

      specify do
        expect { described_class.step?(step_instance) }
          .to delegate_to(described_class, :step_class?)
          .with_arguments(step_class)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
