# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::FormatGemsWithoutEnvs, type: :dry do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(parsed_content: parsed_content) }

      let(:parsed_content) { {} }

      context "when `FormatGemsWithoutEnvs` is NOT successful" do
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

      context "when `FormatGemsWithoutEnvs` is successful" do
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
          <<~RUBY
            gem "bootsnap", ">= 1.4.4", require: false
            gem "pg"
            gem "rails", "~> 6.1.3", ">= 6.1.3.2"
            gem "webpacker", "~> 5.0"
            gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
          RUBY
        end

        it "returns `success` with gems without envs as formatted content" do
          expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
        end

        context "when `parsed_content` does NOT contain `gems`" do
          let(:parsed_content) { {} }
          let(:formatted_content) { "" }

          it "returns `success` with empty string as formatted content" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end

        context "when `parsed_content` does NOT contain `gems` without envs" do
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

          it "returns `success` with empty string as formatted content" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
