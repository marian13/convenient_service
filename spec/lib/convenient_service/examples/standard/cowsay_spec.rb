# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Cowsay, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature::Configs::Standard) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".print" do
      subject(:entry) { described_class.print(text, out: out) }

      let(:text) { "foo" }
      let(:out) { Tempfile.new }

      specify do
        expect { entry }
          .to delegate_to(described_class::Services::Print, :result)
          .with_arguments(text: text, out: out)
          .and_return_its_value
      end

      context "when `text` is NOT passed" do
        subject(:entry) { described_class.print(out: out) }

        it "defaults to `\"Hello World!\"`" do
          expect { entry }
            .to delegate_to(described_class::Services::Print, :result)
            .with_arguments(text: "Hello World!", out: out)
            .and_return_its_value
        end
      end

      ##
      # FIX: `stub_service` does NOT work in combination with `delegate_to`.
      #
      # context "when `out` is NOT passed" do
      #   include ConvenientService::RSpec::Helpers::StubService
      #
      #   subject(:entry) { described_class.print(text) }
      #
      #   it "defaults to `stdout`" do
      #     stub_service(described_class::Services::Print).to return_success
      #
      #     expect { entry }
      #       .to delegate_to(described_class::Services::Print, :result)
      #       .with_arguments(text: text, out: $stdout)
      #   end
      # end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
