# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::V1::Gemfile::Services::MergeSections, type: :rails do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::V1::Gemfile::RailsService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(**default_options) }

      let(:default_options) { {header: header, body: body} }

      let(:header) do
        <<~'RUBY'
          # frozen_string_literal: true

          source "https://rubygems.org"

          git_source(:github) { |repo| "https://github.com/#{repo}.git" }

          ruby "3.0.1"
        RUBY
      end

      let(:body) do
        <<~RUBY
          gem "bootsnap", ">= 1.4.4", require: false

          group :development do
            gem "listen", "~> 3.3"
          end

          group :development, :test do
            gem "rspec-rails"
          end
        RUBY
      end

      context "when `MergeSections` is NOT successful" do
        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?
          context "when header is NOT present" do
            let(:header) { "" }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(header: "can't be blank").of_service(described_class).without_step
            end
          end

          context "when body is NOT present" do
            let(:body) { "" }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(body: "can't be blank").of_service(described_class).without_step
            end
          end
        end
      end

      context "when `MergeSections` is successful" do
        it "returns `success` with contated header and body" do
          expect(result).to be_success.with_data(merged_sections: "#{header}\n#{body}").of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
