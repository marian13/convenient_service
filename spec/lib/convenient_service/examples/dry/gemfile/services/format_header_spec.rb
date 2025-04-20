# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::FormatHeader, type: :dry do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(parsed_content: parsed_content, skip_frozen_string_literal: skip_frozen_string_literal) }

      let(:parsed_content) { {} }
      let(:skip_frozen_string_literal) { false }

      context "when `FormatHeader` is NOT successful" do
        context "when `parsed_content` is NOT hash" do
          let(:parsed_content) { [] }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("parsed_content must be a hash").of_service(described_class).without_step
          end
        end

        context "when `parsed_content` is hash" do
          context "when `parsed_content` has `ruby` key" do
            context "when value for `ruby` is NOT array" do
              let(:parsed_content) { {ruby: {}} }

              it "returns `error` with `data`" do
                expect(result).to be_error.with_data(parsed_content: [:ruby, ["must be an array"]]).of_service(described_class).without_step
              end
            end

            context "when value for `ruby` is array" do
              context "when any item from that array is NOT string" do
                let(:parsed_content) { {ruby: [42]} }

                it "returns `error` with `data`" do
                  expect(result).to be_error.with_data(parsed_content: [:ruby, {0 => ["must be a string"]}]).of_service(described_class).without_step
                end
              end
            end
          end

          context "when `parsed_content` has `source` key" do
            context "when value for `source` is NOT array" do
              let(:parsed_content) { {source: {}} }

              it "returns `error` with `data`" do
                expect(result).to be_error.with_data(parsed_content: [:source, ["must be an array"]]).of_service(described_class).without_step
              end
            end

            context "when value for `source` is array" do
              context "when any item from that array is NOT string" do
                let(:parsed_content) { {source: [42]} }

                it "returns `error` with `data`" do
                  expect(result).to be_error.with_data(parsed_content: [:source, {0 => ["must be a string"]}]).of_service(described_class).without_step
                end
              end
            end
          end

          context "when `parsed_content` has `git_source` key" do
            context "when value for `git_source` is NOT array" do
              let(:parsed_content) { {git_source: {}} }

              it "returns `error` with `data`" do
                expect(result).to be_error.with_data(parsed_content: [:git_source, ["must be an array"]]).of_service(described_class).without_step
              end
            end

            context "when value for `git_source` is array" do
              context "when any item from that array is NOT string" do
                let(:parsed_content) { {git_source: [42]} }

                it "returns `error` with `data`" do
                  expect(result).to be_error.with_data(parsed_content: [:git_source, {0 => ["must be a string"]}]).of_service(described_class).without_step
                end
              end
            end
          end
        end

        context "when `skip_frozen_string_literal` is NOT boolean" do
          let(:skip_frozen_string_literal) { 42 }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("skip_frozen_string_literal must be boolean").of_service(described_class).without_step
          end
        end
      end

      context "when `FormatHeader` is successful" do
        let(:skip_frozen_string_literal) { false }

        let(:parsed_content) do
          {
            ruby: [
              %(ruby "3.0.1")
            ],
            source: [
              %(source "https://rubygems.org")
            ],
            git_source: [
              %(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })
            ]
          }
        end

        let(:formatted_content) do
          <<~'RUBY'
            # frozen_string_literal: true

            source "https://rubygems.org"

            git_source(:github) { |repo| "https://github.com/#{repo}.git" }

            ruby "3.0.1"
          RUBY
        end

        it "returns `success` with formatted content" do
          expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
        end

        context "when `parsed_content` does NOT contains `ruby`" do
          let(:parsed_content) do
            {
              source: [
                %(source "https://rubygems.org")
              ],
              git_source: [
                %(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })
              ]
            }
          end

          let(:formatted_content) do
            <<~'RUBY'
              # frozen_string_literal: true

              source "https://rubygems.org"

              git_source(:github) { |repo| "https://github.com/#{repo}.git" }
            RUBY
          end

          it "returns `success` with formatted content without `ruby`" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end

        context "when `parsed_content` does NOT contains `source`" do
          let(:parsed_content) do
            {
              ruby: [
                %(ruby "3.0.1")
              ],
              git_source: [
                %(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })
              ]
            }
          end

          let(:formatted_content) do
            <<~'RUBY'
              # frozen_string_literal: true

              git_source(:github) { |repo| "https://github.com/#{repo}.git" }

              ruby "3.0.1"
            RUBY
          end

          it "returns `success` with formatted content without `source`" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end

        context "when `parsed_content` does NOT contains `git_source`" do
          let(:parsed_content) do
            {
              ruby: [
                %(ruby "3.0.1")
              ],
              source: [
                %(source "https://rubygems.org")
              ]
            }
          end

          let(:formatted_content) do
            <<~RUBY
              # frozen_string_literal: true

              source "https://rubygems.org"

              ruby "3.0.1"
            RUBY
          end

          it "returns `success` with formatted content without `git_source`" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end

        context "when `skip_frozen_string_literal` is set to `true`" do
          let(:skip_frozen_string_literal) { true }

          let(:parsed_content) do
            {
              ruby: [
                %(ruby "3.0.1")
              ],
              source: [
                %(source "https://rubygems.org")
              ],
              git_source: [
                %(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })
              ]
            }
          end

          let(:formatted_content) do
            <<~'RUBY'
              source "https://rubygems.org"

              git_source(:github) { |repo| "https://github.com/#{repo}.git" }

              ruby "3.0.1"
            RUBY
          end

          it "returns `success` with formatted content without `git_source`" do
            expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).without_step
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
