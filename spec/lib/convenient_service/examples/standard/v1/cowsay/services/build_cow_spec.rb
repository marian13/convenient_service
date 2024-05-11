# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Cowsay::Services::BuildCow, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::V1::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result }

      let(:cow) do
        <<~'HEREDOC'.split("\n").map { |line| " " * 10 + line }.join("\n")
          \   ^__^
           \  (oo)\_______
              (__)\       )\/\
                  ||----w |
                  ||     ||
        HEREDOC
      end

      it "returns success with data" do
        expect(result).to be_success.with_data(cow: cow)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
