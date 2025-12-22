# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Arguments::NullArguments, type: :standard do
  let(:null_arguments) { described_class.new }

  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class < ConvenientService::Support::Arguments).to be(true) }
  end

  example_group "instance methods" do
    describe "#args" do
      it "returns empty array" do
        expect(null_arguments.args).to eq([])
      end
    end

    describe "#kwargs" do
      it "returns empty hash" do
        expect(null_arguments.kwargs).to eq({})
      end
    end

    describe "#block" do
      it "returns `nil`" do
        expect(null_arguments.block).to be_nil
      end
    end

    describe "#null_arguments?" do
      it "returns `true`" do
        expect(null_arguments.null_arguments?).to be(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
