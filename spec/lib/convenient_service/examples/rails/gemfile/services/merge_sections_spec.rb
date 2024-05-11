# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::MergeSections, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
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
        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?
          context "when header is NOT present" do
            let(:header) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("header can't be blank").of_service(described_class).without_step
            end
          end

          context "when body is NOT present" do
            let(:body) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("body can't be blank").of_service(described_class).without_step
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
