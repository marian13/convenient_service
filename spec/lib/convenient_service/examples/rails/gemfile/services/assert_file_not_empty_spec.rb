# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::AssertFileNotEmpty, type: :rails do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(path: path) }

      context "when `AssertFileNotEmpty` is NOT successful" do
        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?
          context "when `path` is NOT present" do
            let(:path) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("path can't be blank").of_service(described_class).without_step
            end
          end
        end

        context "when file is empty" do
          ##
          # NOTE: Tempfile uses its own `let` in order to prevent its premature garbage collection.
          #
          let(:tempfile) { Tempfile.new }
          let(:path) { tempfile.path }

          it "returns `failure` with `message`" do
            expect(result).to be_failure.with_message("File with path `#{path}` is empty").of_service(described_class).without_step
          end
        end
      end

      context "when `AssertFileNotEmpty` is successful" do
        ##
        # NOTE: Tempfile uses its own `let` in order to prevent its premature garbage collection.
        #
        let(:tempfile) { Tempfile.new.tap { |file| file.write("content") }.tap(&:close) }
        let(:path) { tempfile.path }

        it "returns `success`" do
          expect(result).to be_success.without_data.of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
