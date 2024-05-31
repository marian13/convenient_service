# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "result" do
    example_group "instance methods" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(data: {foo: :bar})
          end
        end
      end

      let(:result) { service.result }
      let(:key) { :foo }

      describe "#[]" do
        before do
          result.success?
        end

        specify do
          expect { result[key] }
            .to delegate_to(result.data, :[])
            .with_arguments(key)
            .and_return_its_value
        end
      end

      describe "#ud" do
        specify do
          expect { result.ud }
            .to delegate_to(result, :unsafe_data)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#um" do
        specify do
          expect { result.um }
            .to delegate_to(result, :unsafe_message)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#uc" do
        specify do
          expect { result.uc }
            .to delegate_to(result, :unsafe_code)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#ok?" do
        specify do
          expect { result.ok? }
            .to delegate_to(result, :success?)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#not_ok?" do
        specify do
          expect { result.not_ok? }
            .to delegate_to(result, :not_success?)
            .without_arguments
            .and_return_its_value
        end
      end
    end
  end

  example_group "step" do
    example_group "instance methods" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          step :result

          def result
            success(data: {foo: :bar})
          end
        end
      end

      let(:step) { service.new.steps.first }
      let(:key) { :foo }

      describe "#[]" do
        before do
          step.success?
        end

        specify do
          expect { step[key] }
            .to delegate_to(step.data, :[])
            .with_arguments(key)
            .and_return_its_value
        end
      end

      describe "#ud" do
        specify do
          expect { step.ud }
            .to delegate_to(step, :unsafe_data)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#um" do
        specify do
          expect { step.um }
            .to delegate_to(step, :unsafe_message)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#uc" do
        specify do
          expect { step.uc }
            .to delegate_to(step, :unsafe_code)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#ok?" do
        specify do
          expect { step.ok? }
            .to delegate_to(step, :success?)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#not_ok?" do
        specify do
          expect { step.not_ok? }
            .to delegate_to(step, :not_success?)
            .without_arguments
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
