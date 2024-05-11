# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::FormatGemsWithEnvs, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(parsed_content: parsed_content) }

      let(:parsed_content) { {} }

      context "when `FormatGemsWithEnvs` is successful" do
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
          <<~RUBY
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

        it "returns `success` with formatted gems with envs as formatted content (envs are sorted alphabetically)" do
          expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
        end

        context "when `parsed_content` does NOT contain `gems`" do
          let(:parsed_content) { {} }
          let(:formatted_content) { "" }

          it "returns `success` with empty string as formatted content" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end

        context "when `parsed_content` does NOT contain gems with envs" do
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

          it "returns `success` with empty string as formatted content" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
