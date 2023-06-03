# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::MergeSections do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

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

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    if ConvenientService::Dependencies.support_has_result_params_validations_using_active_model_validations?
      context "when merging of sections is NOT successful" do
        context "when header is NOT present" do
          let(:header) { "" }

          it "returns failure with data" do
            expect(result).to be_failure.with_data(header: "can't be blank").of_service(described_class).without_step
          end
        end

        context "when body is NOT present" do
          let(:body) { "" }

          it "returns failure with data" do
            expect(result).to be_failure.with_data(body: "can't be blank").of_service(described_class).without_step
          end
        end
      end
    end

    context "when merging of sections is successful" do
      it "returns success with contated header and body" do
        expect(result).to be_success.with_data(merged_sections: "#{header}\n#{body}").of_service(described_class).without_step
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
