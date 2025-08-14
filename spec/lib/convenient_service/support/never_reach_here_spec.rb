# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::NeverReachHere, type: :standard do
  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class < ConvenientService::Exception).to eq(true) }
  end

  example_group "instance methods" do
    describe "#message" do
      let(:exception) { described_class.new(extra_message: extra_message) }
      let(:extra_message) { "foo" }

      let(:exception_message) do
        <<~TEXT
          The code that was supposed to be unreachable was executed.

          #{extra_message}
        TEXT
      end

      it "returns message concated with extra message passed to constructor" do
        expect(exception.message).to eq(exception_message)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
