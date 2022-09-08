# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::FormatGemsWithoutEnvs do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule
  include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {parsed_content: parsed_content} }
  let(:parsed_content) { {} }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Configs::Standard) }
    it { is_expected.to include_module(ConvenientService::Configs::AssignsAttributesInConstructor::UsingDryInitializer) }
    it { is_expected.to include_module(ConvenientService::Configs::HasResultParamsValidations::UsingDryValidation) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:parsed_content) }
  end

  example_group "validations" do
    example_group "`parsed_content'" do
      subject(:result) { service.result }

      context "when `parsed_content' is NOT hash" do
        let(:parsed_content) { [] }

        it "returns failure" do
          expect(result).to be_failure
        end
      end

      context "when `parsed_content' is hash" do
        context "when that hash is empty" do
          let(:parsed_content) { {} }

          it "does NOT return failure" do
            expect(result).not_to be_failure
          end
        end

        context "when `parsed_content' has `gems' key" do
          context "when value for `gems' is NOT array" do
            let(:parsed_content) { {gems: {}} }

            it "returns failure" do
              expect(result).to be_failure
            end
          end

          context "when value for `gems' is array" do
            context "when any item from that array is NOT hash" do
              let(:parsed_content) { {gems: [42]} }

              it "returns failure" do
                expect(result).to be_failure
              end
            end

            context "when all items from that array are hashes" do
              context "when any hash from that array does NOT contain `envs' key" do
                let(:parsed_content) do
                  {
                    gems: [
                      {
                        line: %(gem "simplecov", require: false)
                      }
                    ]
                  }
                end

                it "returns failure" do
                  expect(result).to be_failure
                end
              end

              context "when any hash from that array does NOT contain `line' key" do
                let(:parsed_content) do
                  {
                    gems: [
                      {
                        envs: [:test]
                      }
                    ]
                  }
                end

                it "returns failure" do
                  expect(result).to be_failure
                end
              end

              context "when all hashes from that array contains both `envs` and `line' keys" do
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

                it "does NOT return failure" do
                  expect(result).not_to be_failure
                end
              end
            end
          end
        end
      end
    end
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
# rubocop:enable RSpec/NestedGroups
