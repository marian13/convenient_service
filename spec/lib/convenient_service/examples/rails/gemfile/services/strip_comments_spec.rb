# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::StripComments, type: :rails do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # include Shoulda::Matchers::ActiveModel
  ##

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "validations" do
  #   subject { service }
  #
  #   it { is_expected.to validate_presence_of(:content) }
  # end
  ##

  example_group "class methods" do
    describe ".result" do
      subject(:result) { service.result }

      let(:service) { described_class.new(**default_options) }

      let(:default_options) { {content: content} }
      let(:npm_package_name) { "strip-comments" }

      let(:content) do
        <<~RUBY
          ##
          # Coloring for debugging.
          #
          gem "awesome_print", "~> 1.9.2"

          ##
          # Helps to avoid N + 1 in GraphQL resolvers.
          #
          gem "batch-loader", "~> 2.0.1"
        RUBY
      end

      let(:content_without_comments) do
        <<~RUBY



          gem "awesome_print", "~> 1.9.2"




          gem "batch-loader", "~> 2.0.1"
        RUBY
      end

      context "when `StripComments` is NOT successful" do
        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?
          context "when content is NOT present" do
            let(:content) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("content can't be blank")
            end
          end
        end

        context "when `strip-comments` npm package is not available" do
          before do
            stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertNpmPackageAvailable)
              .with_arguments(name: npm_package_name)
              .to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_step(ConvenientService::Examples::Rails::Gemfile::Services::AssertNpmPackageAvailable)
          end
        end
      end

      context "when `StripComments` is successful" do
        before do
          stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertNpmPackageAvailable)
            .with_arguments(name: npm_package_name)
            .to return_success

          ##
          # NOTE: Stub for environments where Node.js is not available.
          # TODO: Node.js independent examples.
          #
          stub_service(ConvenientService::Examples::Rails::Gemfile::Services::RunShellCommand).to return_success
        end

        ##
        # NOTE: Stub for environments where Node.js is not available.
        # TODO: Integration test.
        # TODO: different content variations.
        #
        it "returns `success` with content without comments" do
          expect(result).to be_success.with_data({content_without_comments: ""})
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
