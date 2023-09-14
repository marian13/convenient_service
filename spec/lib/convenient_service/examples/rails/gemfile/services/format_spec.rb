# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::Format do
  include ConvenientService::RSpec::Helpers::StubService

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::IncludeModule
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::Results

  let(:service) { described_class.new(path: path) }

  let(:path) { file.path }

  let(:file) { Tempfile.new.tap { |file| file.write(initial_content) }.tap(&:close) }

  let(:initial_content) do
    <<~'RUBY'
      # frozen_string_literal: true

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

      ruby "3.0.1"

      source "https://rubygems.org"

      git_source(:github) { |repo| "https://github.com/#{repo}.git" }
    RUBY
  end

  let(:formatted_content) do
    <<~'RUBY'
      # frozen_string_literal: true

      source "https://rubygems.org"

      git_source(:github) { |repo| "https://github.com/#{repo}.git" }

      ruby "3.0.1"

      gem "bootsnap", ">= 1.4.4", require: false
      gem "pg"
      gem "rails", "~> 6.1.3", ">= 6.1.3.2"
      gem "webpacker", "~> 5.0"
      gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

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
    RUBY
  end

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
        "# frozen_string_literal: true",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
      ]
    }
  end

  ##
  # - https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles
  # - https://github.com/jfelchner/ruby-progressbar/blob/master/lib/progressbar.rb#L20
  #
  let(:progressbar) { instance_double(ProgressBar::Base, increment: true) }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
  end

  example_group "instance methods" do
    describe "#result" do
      subject(:result) { described_class.result(path: path) }

      before do
        stub_service(ConvenientService::Examples::Rails::Gemfile::Services::StripComments)
          .with_arguments(content: initial_content)
          .to return_success
          .with_data(content_without_comments: initial_content)

        allow(ProgressBar).to receive(:create).with(title: "Formatting", total: service.steps.count).and_return(progressbar)
      end

      context "when formatting is NOT successful" do
        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?
          context "when path is NOT present" do
            let(:path) { nil }

            it "returns error with data" do
              expect(result).to be_error.with_data(path: "can't be blank").of_service(described_class).without_step
            end
          end
        end

        context "when reading of file content is NOT successful" do
          let(:path) { "non_existing_path" }

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Rails::Gemfile::Services::ReadFileContent)
          end
        end

        context "when stripping of comments is NOT successful" do
          before do
            stub_service(ConvenientService::Examples::Rails::Gemfile::Services::StripComments)
              .with_arguments(content: initial_content)
              .to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Rails::Gemfile::Services::StripComments)
          end
        end

        context "when parsing of content is NOT successful" do
          ##
          # NOTE: Contains no valid Ruby syntax.
          #
          let(:initial_content) do
            <<~'RUBY'
              gem\\
            RUBY
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Rails::Gemfile::Services::ParseContent)
          end
        end

        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?
          context "when merging of sections is NOT successful" do
            let(:initial_content) { "ruby \"3.0.1\"" }

            it "returns intermediate step result" do
              expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Rails::Gemfile::Services::MergeSections)
            end
          end
        end
      end

      context "when formatting is successful" do
        specify do
          ##
          # TODO: `delegate_to_service`?
          #
          expect { result }
            .to delegate_to(ConvenientService::Examples::Rails::Gemfile::Services::FormatHeader, :result)
            .with_arguments(parsed_content: parsed_content)
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Rails::Gemfile::Services::FormatBody, :result)
            .with_arguments(parsed_content: parsed_content)
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Rails::Gemfile::Services::ReplaceFileContent, :result)
            .with_arguments(path: path, content: formatted_content)
        end

        it "returns success" do
          expect(result).to be_success.of_service(described_class)
        end

        it "prints progress bar after each step" do
          result

          expect(progressbar).to have_received(:increment).exactly(service.steps.count).times
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
