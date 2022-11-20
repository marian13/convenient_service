# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Cowsay::Services::BuildCloud do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when text is NOT passed" do
        subject(:result) { described_class.result }

        let(:cloud) do
          <<~HEREDOC
             ______________
            < Hello World! >
             --------------
          HEREDOC
        end

        it "returns success with cloud with \"Hello World!\"" do
          expect(result).to be_success.with_data(cloud: cloud)
        end
      end

      context "when text is passed" do
        subject(:result) { described_class.result(text: text) }

        let(:cloud) do
          <<~HEREDOC
             _____
            < #{text} >
             -----
          HEREDOC
        end

        let(:text) { "Hi!" }

        it "returns success with cloud with text" do
          expect(result).to be_success.with_data(cloud: cloud)
        end

        example_group "borders" do
          let(:first_line_length) { result.data[:cloud].lines.first.strip.length }
          let(:last_line_length) { result.data[:cloud].lines.last.strip.length }

          it "scales borders depending on text length" do
            result.success?

            expect([first_line_length, last_line_length].uniq).to eq([text.length + 2])
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
