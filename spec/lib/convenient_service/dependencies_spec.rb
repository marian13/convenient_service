# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Dependencies, type: :standard do
  example_group "class methods" do
    describe ".support_logger_non_integer_levels?" do
      context "when `logger` version is lower than 1.3.0" do
        before do
          allow(described_class.logger).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("1.2.0"))
        end

        it "returns `false`" do
          expect(described_class.support_logger_non_integer_levels?).to eq(false)
        end
      end

      context "when `logger` version is equal to 1.3.0" do
        before do
          allow(described_class.logger).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("1.3.0"))
        end

        it "returns `true`" do
          expect(described_class.support_logger_non_integer_levels?).to eq(true)
        end
      end

      context "when `logger` version is greaten than to 1.3.0" do
        before do
          allow(described_class.logger).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("1.4.0"))
        end

        it "returns `true`" do
          expect(described_class.support_logger_non_integer_levels?).to eq(true)
        end
      end
    end

    describe ".support_has_j_send_result_params_validations_using_active_model_validations_plugin?" do
      context "when `ActiveModel` is NOT loaded" do
        before do
          allow(described_class.active_model).to receive(:loaded?).and_return(false)
        end

        it "returns `false`" do
          expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations_plugin?).to eq(false)
        end
      end

      context "when `ActiveModel` is loaded" do
        before do
          allow(described_class.active_model).to receive(:loaded?).and_return(true)
        end

        context "when `Ruby` version is lower than 3" do
          before do
            allow(described_class.ruby).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("2.7.0"))
          end

          it "returns `true`" do
            expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations_plugin?).to eq(true)
          end
        end

        context "when `ActiveModel` version is greater than 6" do
          before do
            allow(described_class.active_model).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("6.1.0"))
          end

          it "returns `true`" do
            expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations_plugin?).to eq(true)
          end
        end

        context "when `Ruby` version > 3 and `ActiveModel` version < 6" do
          before do
            allow(described_class.ruby).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("3.0.0"))
            allow(described_class.active_model).to receive(:version).and_return(ConvenientService::Dependencies::Queries::Version.new("5.2.0"))
          end

          it "returns `false`" do
            expect(described_class.support_has_j_send_result_params_validations_using_active_model_validations_plugin?).to eq(false)
          end
        end
      end
    end

    describe ".ruby" do
      it "returns `ConvenientService::Dependencies::Queries::Ruby`" do
        expect(described_class.ruby).to eq(ConvenientService::Dependencies::Queries::Ruby)
      end
    end

    describe ".rspec" do
      it "returns `ConvenientService::Dependencies::Queries::Gems::RSpec`" do
        expect(described_class.rspec).to eq(ConvenientService::Dependencies::Queries::Gems::RSpec)
      end
    end

    describe ".active_model" do
      it "returns `ConvenientService::Dependencies::Queries::Gems::ActiveModel`" do
        expect(described_class.active_model).to eq(ConvenientService::Dependencies::Queries::Gems::ActiveModel)
      end
    end

    describe ".logger" do
      it "returns `ConvenientService::Dependencies::Queries::Gems::Logger`" do
        expect(described_class.logger).to eq(ConvenientService::Dependencies::Queries::Gems::Logger)
      end
    end

    describe ".paint" do
      it "returns `ConvenientService::Dependencies::Queries::Gems::Paint`" do
        expect(described_class.paint).to eq(ConvenientService::Dependencies::Queries::Gems::Paint)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
