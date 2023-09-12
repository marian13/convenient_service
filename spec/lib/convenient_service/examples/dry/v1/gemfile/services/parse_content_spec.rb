# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Dry::V1::Gemfile::Services::ParseContent do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {content: content} }

  let(:default_content) do
    <<~'RUBY'
      ruby "3.0.1"
      source "https://rubygems.org"

      git_source(:github) { |repo| "https://github.com/#{repo}.git" }

      gem "bootsnap", ">= 1.4.4", require: false
      gem "pg"
      gem "rails", "~> 6.1.3", ">= 6.1.3.2"
      gem "webpacker", "~> 5.0"

      group :development do
        gem "listen", "~> 3.3"
        gem "web-console", ">= 4.1.0"
      end

      group :development, :test do
        gem "rspec-rails"
      end

      group :test do
        gem "simplecov", require: false
      end

      gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
    RUBY
  end

  let(:default_parsed_content) do
    {
      ruby: [
        %(ruby "3.0.1")
      ],
      source: [
        %(source "https://rubygems.org")
      ],
      git_source: [
        %(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })
      ],
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
          envs: [:development],
          line: %(gem "listen", "~> 3.3")
        },
        {
          envs: [:development],
          line: %(gem "web-console", ">= 4.1.0")
        },
        {
          envs: [:development, :test],
          line: %(gem "rspec-rails")
        },
        {
          envs: [:test],
          line: %(gem "simplecov", require: false)
        },
        {
          envs: [],
          line: %(gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby])
        }
      ],
      rest: [
        "",
        "",
        "",
        "",
        "",
        ""
      ]
    }
  end

  let(:content) { default_content }
  let(:parsed_content) { default_parsed_content }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::V1::Gemfile::DryService::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    ##
    # Adds a value to an object immutably.
    # Returns a new object.
    #
    def add(value, to:)
      object = to

      case object
      when String
        object + value
      when Hash
        object.merge(value) { |key, lines, line| [*lines, line] }
      end
    end

    ##
    # Removes a value to from an object immutably.
    # Returns a new object.
    #
    def remove(value, from:, condition: nil)
      object = from

      case object
      when String
        object.gsub(value, "")
      when Hash
        if condition
          {**object, value => object[value].reject(&condition)}
        else
          object.reject { |key| key == value }
        end
      end
    end

    context "when content is NOT present" do
      let(:content) { "" }

      it "returns failure with data" do
        expect(result).to be_failure.with_data(content: "must be filled")
      end
    end

    context "when content has invalid Ruby syntax" do
      before do
        stub_service(ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertValidRubySyntax)
          .with_arguments(content: content)
          .to return_error
      end

      it "returns intermediate step result" do
        expect(result).to be_not_success.of_step(ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertValidRubySyntax)
      end
    end

    context "when content has valid Ruby syntax" do
      before do
        stub_service(ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertValidRubySyntax)
          .with_arguments(content: content)
          .to return_success
      end

      it "returns success with parsed content" do
        expect(result).to be_success.with_data(parsed_content: parsed_content)
      end

      context "when `ruby` is missing" do
        let(:content) { remove(%(ruby "3.0.1"\n), from: default_content) }
        let(:parsed_content) { remove(:ruby, from: default_parsed_content) }

        it "returns success with parsed content without `ruby`" do
          expect(result).to be_success.with_data(parsed_content: parsed_content)
        end
      end

      context "when `source` is missing" do
        let(:content) { remove(%(source "https://rubygems.org"\n), from: default_content) }
        let(:parsed_content) { remove(:source, from: default_parsed_content) }

        it "returns success with parsed content without `source`" do
          expect(result).to be_success.with_data(parsed_content: parsed_content)
        end
      end

      context "when `git_source` is missing" do
        let(:content) { remove(%(git_source(:github) { |repo| "https://github.com/\#{repo}.git" }\n), from: default_content) }
        let(:parsed_content) { remove(:git_source, from: default_parsed_content) }

        it "returns success with parsed content without `git_source`" do
          expect(result).to be_success.with_data(parsed_content: parsed_content)
        end
      end

      context "when `gems` without envs is missing" do
        let(:content) { remove(/^gem.*?\n/, from: default_content) }
        let(:parsed_content) { remove(:gems, condition: ->(gem) { gem[:envs].none? }, from: default_parsed_content) }

        it "returns success with parsed content without `gems` without envs" do
          expect(result).to be_success.with_data(parsed_content: parsed_content)
        end
      end

      context "when `gems_with_envs` is missing" do
        let(:content) { remove(/^group.*?end\n/m, from: default_content) }
        let(:parsed_content) { remove(:gems, condition: ->(gem) { gem[:envs].any? }, from: default_parsed_content) }

        it "returns success with parsed content without `gems` with envs" do
          expect(result).to be_success.with_data(parsed_content: parsed_content)
        end
      end

      context "when same group is used multiple times" do
        let(:content) do
          add(
            <<~RUBY,
              group :development, :test do
                gem "byebug", "~> 11.1.3"
              end
            RUBY
            to: default_content
          )
        end

        let(:parsed_content) do
          add(
            {
              gems: {
                envs: [:development, :test],
                line: %(gem "byebug", "~> 11.1.3")
              }
            },
            to: default_parsed_content
          )
        end

        it "returns success with parsed content with combined gems for same group" do
          expect(result).to be_success.with_data(parsed_content: parsed_content)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
