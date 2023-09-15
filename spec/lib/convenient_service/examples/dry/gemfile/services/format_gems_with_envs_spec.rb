# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::FormatGemsWithEnvs do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:result) { described_class.result(parsed_content: parsed_content) }
  let(:parsed_content) { {} }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when formatting of gems with envs is NOT successful" do
        context "when `parsed_content` is NOT hash" do
          let(:parsed_content) { [] }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("parsed_content must be a hash").of_service(described_class).without_step
          end
        end

        context "when `parsed_content` is hash" do
          context "when `parsed_content` has `gems` key" do
            context "when value for `gems` is NOT array" do
              let(:parsed_content) { {gems: {}} }

              it "returns `error` with `data`" do
                expect(result).to be_error.with_data(parsed_content: [:gems, ["must be an array"]]).of_service(described_class).without_step
              end
            end

            context "when value for `gems` is array" do
              context "when any item from that array is NOT hash" do
                let(:parsed_content) { {gems: [42]} }

                it "returns `error` with `data`" do
                  expect(result).to be_error.with_data(parsed_content: [:gems, {0 => ["must be a hash"]}]).of_service(described_class).without_step
                end
              end

              context "when all items from that array are hashes" do
                context "when any hash from that array does NOT contain `envs` key" do
                  let(:parsed_content) do
                    {
                      gems: [
                        {
                          line: %(gem "simplecov", require: false)
                        }
                      ]
                    }
                  end

                  it "returns `error` with `data`" do
                    expect(result).to be_error.with_data(parsed_content: [:gems, {0 => {envs: ["is missing"]}}]).of_service(described_class).without_step
                  end
                end

                context "when any hash from that array does NOT contain `line` key" do
                  let(:parsed_content) do
                    {
                      gems: [
                        {
                          envs: [:test]
                        }
                      ]
                    }
                  end

                  it "returns `error` with `data`" do
                    expect(result).to be_error.with_data(parsed_content: [:gems, {0 => {line: ["is missing"]}}]).of_service(described_class).without_step
                  end
                end
              end
            end
          end
        end
      end

      context "when formatting of gems with envs is successful" do
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

          it "returns `success` with empty string as formatted content" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
