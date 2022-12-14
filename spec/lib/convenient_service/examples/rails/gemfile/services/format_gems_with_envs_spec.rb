# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::FormatGemsWithEnvs do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule
  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {parsed_content: parsed_content} }
  let(:parsed_content) { {} }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
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
            envs: [:development],
            line: %(gem "listen", "~> 3.3")
          },
          {
            envs: [:development, :test],
            line: %(gem "rspec-rails")
          },
          {
            envs: [:test],
            line: %(gem "simplecov", require: false)
          }
        ]
      }
    end

    let(:formatted_content) do
      <<~'RUBY'
        group :development do
          gem "listen", "~> 3.3"
        end

        group :development, :test do
          gem "rspec-rails"
        end

        group :test do
          gem "simplecov", require: false
        end
      RUBY
    end

    it "returns success with formatted gems with envs as formatted content (envs are sorted alphabetically)" do
      expect(result).to be_success.with_data(formatted_content: formatted_content)
    end

    context "when `parsed_content` does NOT contain `gems`" do
      let(:parsed_content) { {} }
      let(:formatted_content) { "" }

      it "returns success with empty string as formatted content" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end

    context "when `parsed_content` does NOT contain `gems` with envs" do
      let(:parsed_content) do
        {
          gems: [
            {
              envs: [],
              line: %(gem "bootsnap", ">= 1.4.4", require: false)
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
