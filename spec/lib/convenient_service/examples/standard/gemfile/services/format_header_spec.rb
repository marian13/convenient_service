# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::FormatHeader do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(parsed_content: parsed_content, skip_frozen_string_literal: skip_frozen_string_literal) }

      let(:parsed_content) { {} }
      let(:skip_frozen_string_literal) { false }

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
