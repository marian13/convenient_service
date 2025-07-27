# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:validator) { described_class.new(matcher: matcher) }
  let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:result) { service.result }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { validator }

      it { is_expected.to have_attr_reader(:matcher) }
    end

    describe "#valid_result?" do
      specify do
        expect { validator.valid_result? }
          .to delegate_to(described_class::Commands::ValidateResult, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_code?" do
      specify do
        expect { validator.valid_result_code? }
          .to delegate_to(described_class::Commands::ValidateResultCode, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_data?" do
      specify do
        expect { validator.valid_result_data? }
          .to delegate_to(described_class::Commands::ValidateResultData, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_message?" do
      specify do
        expect { validator.valid_result_message? }
          .to delegate_to(described_class::Commands::ValidateResultMessage, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_service?" do
      specify do
        expect { validator.valid_result_service? }
          .to delegate_to(described_class::Commands::ValidateResultService, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_original_service?" do
      specify do
        expect { validator.valid_result_original_service? }
          .to delegate_to(described_class::Commands::ValidateResultOriginalService, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_status?" do
      specify do
        expect { validator.valid_result_status? }
          .to delegate_to(described_class::Commands::ValidateResultStatus, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_step?" do
      specify do
        expect { validator.valid_result_step? }
          .to delegate_to(described_class::Commands::ValidateResultStep, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    describe "#valid_result_type?" do
      specify do
        expect { validator.valid_result_type? }
          .to delegate_to(described_class::Commands::ValidateResultType, :call)
          .with_arguments(validator: validator)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(validator == other).to be_nil
          end
        end

        context "when `other` has different `matcher`" do
          let(:other) { described_class.new(matcher: be_success) }

          it "returns `false`" do
            expect(validator == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(matcher: matcher) }

          it "returns `true`" do
            expect(validator == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
