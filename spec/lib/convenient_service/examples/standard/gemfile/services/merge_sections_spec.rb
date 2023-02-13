# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::MergeSections do
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
    <<~'RUBY'
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

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:header) }
    it { is_expected.to have_attr_reader(:body) }
  end

  describe "#result" do
    subject(:result) { service.result }

    context "when merging of sections is NOT successful" do
      context "when header is NOT valid" do
        context "when header is `nil`" do
          let(:header) { nil }

          it "returns failure with data" do
            expect(result).to be_failure.with_data(header: "Header is `nil`").of_service(described_class).of_step(:validate_header)
          end
        end

        context "when header is empty string" do
          let(:header) { "" }

          it "returns failure with data" do
            expect(result).to be_failure.with_data(header: "Header is empty").of_service(described_class).of_step(:validate_header)
          end
        end
      end

      context "when body is NOT valid" do
        context "when body is `nil`" do
          let(:body) { nil }

          it "returns failure with data" do
            expect(result).to be_failure.with_data(body: "Body is `nil`").of_service(described_class).of_step(:validate_body)
          end
        end

        context "when body is empty string" do
          let(:body) { "" }

          it "returns failure with data" do
            expect(result).to be_failure.with_data(body: "Body is empty").of_service(described_class).of_step(:validate_body)
          end
        end
      end
    end

    context "when merging of sections is successful" do
      it "returns success with contated header and body" do
        expect(result).to be_success.with_data(merged_sections: "#{header}\n#{body}").of_service(described_class).of_step(:result)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
