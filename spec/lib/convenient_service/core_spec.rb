# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:entity_class) { Class.new }

      specify do
        expect(entity_class.include described_class).to include_module(described_class::Concern)
      end

      ##
      # NOTE: Ensures `__convenient_service_config__` is called in the `included` block.
      #
      specify do
        expect { entity_class.include described_class }
          .to delegate_to(ConvenientService::Core::Entities::Config, :new)
          .with_arguments(klass: entity_class)
      end
    end
  end

  example_group "class methods" do
    describe ".entity_class?" do
      context "when `entity` is NOT class" do
        let(:entity_class) { 42 }

        it "returns `false`" do
          expect(described_class.entity_class?(entity_class)).to be(false)
        end
      end

      context "when `entity` is class" do
        context "when `entity` is NOT entity class" do
          let(:entity_class) { Class.new }

          it "returns `false`" do
            expect(described_class.entity_class?(entity_class)).to be(false)
          end
        end

        context "when `entity` is entity class" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:entity_class) { service_class }

          it "returns `true`" do
            expect(described_class.entity_class?(entity_class)).to be(true)
          end
        end
      end

      example_group "comprehensive suite" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:service_instance) { service_class.new }

        let(:feature_class) do
          Class.new do
            include ConvenientService::Feature::Standard::Config

            entry :main

            def main
              :main_entry_value
            end
          end
        end

        let(:feature_instance) { feature_class.new }

        specify { expect(described_class.entity_class?(service_class)).to be(true) }
        specify { expect(described_class.entity_class?(service_class.result_class)).to be(true) }
        specify { expect(described_class.entity_class?(service_class.result_class.data_class)).to be(true) }
        specify { expect(described_class.entity_class?(service_class.result_class.message_class)).to be(true) }
        specify { expect(described_class.entity_class?(service_class.result_class.code_class)).to be(true) }
        specify { expect(described_class.entity_class?(service_class.result_class.status_class)).to be(true) }
        specify { expect(described_class.entity_class?(service_class.step_class)).to be(true) }
        specify { expect(described_class.entity_class?(feature_class)).to be(true) }

        specify { expect(described_class.entity_class?(service_instance)).to be(false) }
        specify { expect(described_class.entity_class?(service_instance.result)).to be(false) }
        specify { expect(described_class.entity_class?(service_instance.result.unsafe_data)).to be(false) }
        specify { expect(described_class.entity_class?(service_instance.result.unsafe_message)).to be(false) }
        specify { expect(described_class.entity_class?(service_instance.result.unsafe_code)).to be(false) }
        specify { expect(described_class.entity_class?(service_instance.result.status)).to be(false) }
        specify { expect(described_class.entity_class?(service_instance.steps.first)).to be(false) }
        specify { expect(described_class.entity_class?(feature_instance)).to be(false) }
      end
    end

    describe ".entity?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { described_class.entity?(service_instance) }
          .to delegate_to(described_class, :entity_class?)
          .with_arguments(service_class)
          .and_return_its_value
      end

      example_group "comprehensive suite" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:service_instance) { service_class.new }

        specify { expect(described_class.entity?(service_class)).to be(false) }
        specify { expect(described_class.entity?(service_class.result_class)).to be(false) }
        specify { expect(described_class.entity?(service_class.result_class.data_class)).to be(false) }
        specify { expect(described_class.entity?(service_class.result_class.message_class)).to be(false) }
        specify { expect(described_class.entity?(service_class.result_class.code_class)).to be(false) }
        specify { expect(described_class.entity?(service_class.result_class.status_class)).to be(false) }
        specify { expect(described_class.entity?(service_class.step_class)).to be(false) }

        specify { expect(described_class.entity?(service_instance)).to be(true) }
        specify { expect(described_class.entity?(service_instance.result)).to be(true) }
        specify { expect(described_class.entity?(service_instance.result.unsafe_data)).to be(true) }
        specify { expect(described_class.entity?(service_instance.result.unsafe_message)).to be(true) }
        specify { expect(described_class.entity?(service_instance.result.unsafe_code)).to be(true) }
        specify { expect(described_class.entity?(service_instance.result.status)).to be(true) }
        specify { expect(described_class.entity?(service_instance.steps.first)).to be(true) }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
