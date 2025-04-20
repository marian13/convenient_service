# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::FormatBody, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(parsed_content: parsed_content) }

      let(:parsed_content) { {} }

      context "when `FormatBody` is successful" do
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
                envs: [],
                line: %(gem "bootsnap", ">= 1.4.4", require: false)
              }
            ]
          }
        end

        let(:formatted_content) do
          <<~RUBY
            gem "bootsnap", ">= 1.4.4", require: false

            group :development do
              gem "listen", "~> 3.3"
            end

            group :development, :test do
              gem "rspec-rails"
            end
          RUBY
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::Gemfile::Services::FormatGemsWithoutEnvs, :result)
            .with_arguments(parsed_content: parsed_content)
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::Gemfile::Services::FormatGemsWithEnvs, :result)
            .with_arguments(parsed_content: parsed_content)
        end

        it "returns `success` with formatted content" do
          expect(result).to be_success.with_data(formatted_content: formatted_content).of_service(described_class).of_step(:result)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
