# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Dependencies do
  example_group "class methods" do
    describe ".support_logger_non_integer_levels?" do
      context "when `logger` version is lower than 1.3.0" do
        before do
          allow(described_class.logger).to receive(:version).and_return(ConvenientService::Support::Version.new("1.2.0"))
        end

        it "returns `false`" do
          expect(described_class.support_logger_non_integer_levels?).to eq(false)
        end
      end

      context "when `logger` version is equal to 1.3.0" do
        before do
          allow(described_class.logger).to receive(:version).and_return(ConvenientService::Support::Version.new("1.3.0"))
        end

        it "returns `true`" do
          expect(described_class.support_logger_non_integer_levels?).to eq(true)
        end
      end

      context "when `logger` version is greaten than to 1.3.0" do
        before do
          allow(described_class.logger).to receive(:version).and_return(ConvenientService::Support::Version.new("1.4.0"))
        end

        it "returns `true`" do
          expect(described_class.support_logger_non_integer_levels?).to eq(true)
        end
      end
    end

    describe ".support_has_j_send_result_params_validations_using_active_model_validations?" do
      context "when `ActiveModel` is NOT loaded" do
        before do
          allow(described_class.active_model).to receive(:loaded?).and_return(false)
        end

        it "returns `false`" do
          expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations?).to eq(false)
        end
      end

      context "when `ActiveModel` is loaded" do
        before do
          allow(described_class.active_model).to receive(:loaded?).and_return(true)
        end

        context "when `Ruby` version is lower than 3" do
          before do
            allow(described_class.ruby).to receive(:version).and_return(ConvenientService::Support::Version.new("2.7.0"))
          end

          it "returns `true`" do
            expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations?).to eq(true)
          end
        end

        context "when `ActiveModel` version is greater than 6" do
          before do
            allow(described_class.active_model).to receive(:version).and_return(ConvenientService::Support::Version.new("6.1.0"))
          end

          it "returns `true`" do
            expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations?).to eq(true)
          end
        end

        context "when `Ruby` version > 3 and `ActiveModel` version < 6" do
          before do
            allow(described_class.ruby).to receive(:version).and_return(ConvenientService::Support::Version.new("3.0.0"))
            allow(described_class.active_model).to receive(:version).and_return(ConvenientService::Support::Version.new("5.2.0"))
          end

          it "returns `false`" do
            expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations?).to eq(false)
          end
        end
      end
    end

    describe ".ruby" do
      it "returns `ConvenientService::Support::Ruby`" do
        expect(described_class.ruby).to eq(ConvenientService::Support::Ruby)
      end
    end

    describe ".rspec" do
      it "returns `ConvenientService::Support::Gems::RSpec`" do
        expect(described_class.rspec).to eq(ConvenientService::Support::Gems::RSpec)
      end
    end

    describe ".active_model" do
      it "returns `ConvenientService::Support::Gems::ActiveModel`" do
        expect(described_class.active_model).to eq(ConvenientService::Support::Gems::ActiveModel)
      end
    end

    describe ".logger" do
      it "returns `ConvenientService::Support::Gems::Logger`" do
        expect(described_class.logger).to eq(ConvenientService::Support::Gems::Logger)
      end
    end

    describe ".paint" do
      it "returns `ConvenientService::Support::Gems::Paint`" do
        expect(described_class.paint).to eq(ConvenientService::Support::Gems::Paint)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
