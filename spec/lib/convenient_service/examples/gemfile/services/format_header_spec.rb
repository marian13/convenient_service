# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Gemfile::Services::FormatHeader do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule
  include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {parsed_content: parsed_content, skip_frozen_string_literal: skip_frozen_string_literal} }
  let(:parsed_content) { {} }
  let(:skip_frozen_string_literal) { false }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Configs::Standard) }
    it { is_expected.to include_module(ConvenientService::Configs::AssignsAttributesInConstructor::UsingDryInitializer) }
    it { is_expected.to include_module(ConvenientService::Configs::HasResultParamsValidations::UsingDryValidation) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:parsed_content) }
    it { is_expected.to have_attr_reader(:skip_frozen_string_literal) }
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

        context "when `parsed_content' has `ruby' key" do
          context "when value for `ruby' is NOT array" do
            let(:parsed_content) { {ruby: {}} }

            it "returns failure" do
              expect(result).to be_failure
            end
          end

          context "when value for `ruby' is array" do
            context "when any item from that array is NOT string" do
              let(:parsed_content) { {ruby: [42]} }

              it "returns failure" do
                expect(result).to be_failure
              end
            end

            context "when all items from that array are strings" do
              let(:parsed_content) { {ruby: [%(ruby "3.0.1")]} }

              it "does NOT return failure" do
                expect(result).not_to be_failure
              end
            end
          end
        end

        context "when `parsed_content' has `source' key" do
          context "when value for `source' is NOT array" do
            let(:parsed_content) { {source: {}} }

            it "returns failure" do
              expect(result).to be_failure
            end
          end

          context "when value for `source' is array" do
            context "when any item from that array is NOT string" do
              let(:parsed_content) { {source: [42]} }

              it "returns failure" do
                expect(result).to be_failure
              end
            end

            context "when all items from that array are strings" do
              let(:parsed_content) { {source: [%(source "https://rubygems.org")]} }

              it "does NOT return failure" do
                expect(result).not_to be_failure
              end
            end
          end
        end

        context "when `parsed_content' has `git_source' key" do
          context "when value for `git_source' is NOT array" do
            let(:parsed_content) { {git_source: {}} }

            it "returns failure" do
              expect(result).to be_failure
            end
          end

          context "when value for `git_source' is array" do
            context "when any item from that array is NOT string" do
              let(:parsed_content) { {git_source: [42]} }

              it "returns failure" do
                expect(result).to be_failure
              end
            end

            context "when all items from that array are strings" do
              let(:parsed_content) { {git_source: [%(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })]} }

              it "does NOT return failure" do
                expect(result).not_to be_failure
              end
            end
          end
        end
      end
    end

    example_group "`skip_frozen_string_literal'" do
      subject(:result) { described_class.result(parsed_content: parsed_content, skip_frozen_string_literal: skip_frozen_string_literal) }

      context "when `skip_frozen_string_literal' is NOT boolean" do
        let(:skip_frozen_string_literal) { 42 }

        it "returns failure" do
          expect(result).to be_failure
        end
      end

      context "when `skip_frozen_string_literal' is boolean" do
        let(:skip_frozen_string_literal) { false }

        it "does NOT return failure" do
          expect(result).not_to be_failure
        end
      end
    end
  end

  describe "#result" do
    subject(:result) { described_class.result(parsed_content: parsed_content, skip_frozen_string_literal: skip_frozen_string_literal) }

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

    it "returns success with formatted content" do
      expect(result).to be_success.with_data(formatted_content: formatted_content)
    end

    context "when `parsed_content' does NOT contains `ruby'" do
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

      it "returns success with formatted content without `ruby'" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end

    context "when `parsed_content' does NOT contains `source'" do
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

      it "returns success with formatted content without `source'" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end

    context "when `parsed_content' does NOT contains `git_source'" do
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
        <<~'RUBY'
          # frozen_string_literal: true

          source "https://rubygems.org"

          ruby "3.0.1"
        RUBY
      end

      it "returns success with formatted content without `git_source'" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end

    context "when `skip_frozen_string_literal' is set to `true'" do
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

      it "returns success with formatted content without `git_source'" do
        expect(result).to be_success.with_data(formatted_content: formatted_content)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
