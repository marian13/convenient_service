# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::FormatGemsWithoutEnvs do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule
  include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {parsed_content: parsed_content} }
  let(:parsed_content) { {} }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsServiceConfig) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:parsed_content) }
  end

  describe "#result" do
    subject(:result) { service.result }

    let(:parsed_content) do
      {
        gems: [
          {
            envs: [],
            line: %(gem "bootsnap", ">= 1.4.4", require: false)
          },
          {
            envs: [],
            line: %(gem "pg")
          },
          {
            envs: [],
            line: %(gem "rails", "~> 6.1.3", ">= 6.1.3.2")
          },
          {
            envs: [],
            line: %(gem "webpacker", "~> 5.0")
          },
          {
            envs: [],
            line: %(gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby])
          }
        ]
      }
    end

    let(:formatted_content) do
      <<~'RUBY'
        gem "bootsnap", ">= 1.4.4", require: false
        gem "pg"
        gem "rails", "~> 6.1.3", ">= 6.1.3.2"
        gem "webpacker", "~> 5.0"
        gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
      RUBY
    end

    it "returns success with gems without envs as formatted content" do
      expect(result).to be_success.with_data(formatted_content: formatted_content)
    end

    context "when `parsed_content' does NOT contain `gems'" do
      let(:parsed_content) { {} }
      let(:formatted_content) { "" }

      it "returns success with empty string as formatted content" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end

    context "when `parsed_content' does NOT contain `gems' without envs" do
      let(:parsed_content) do
        {
          gems: [
            {
              envs: [:test],
              line: %(gem "simplecov", require: false)
            }
          ]
        }
      end

      let(:formatted_content) { "" }

      it "returns success with empty string as formatted content" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end
  end
end
