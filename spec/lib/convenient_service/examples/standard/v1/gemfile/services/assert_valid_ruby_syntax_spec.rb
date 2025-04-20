# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Gemfile::Services::AssertValidRubySyntax, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::V1::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(content: content) }

      let(:content) { double }

      context "when `AssertValidRubySyntax` is NOT successful" do
        context "when `content` does NOT contain valid Ruby syntax" do
          let(:content) { "2 */ 2" }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("`#{content}` contains invalid Ruby syntax").of_service(described_class).without_step
          end
        end
      end

      context "when `AssertValidRubySyntax` is successful" do
        let(:content) { "2 + 2" }

        it "returns `success`" do
          expect(result).to be_success.without_data.of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
