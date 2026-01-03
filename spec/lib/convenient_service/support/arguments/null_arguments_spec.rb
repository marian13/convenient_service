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

  example_group "class methods" do
    describe ".new" do
      it "freezes args" do
        expect(null_arguments.args).to be_frozen
      end

      it "freezes kwargs" do
        expect(null_arguments.kwargs).to be_frozen
      end
    end
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

    describe "#block=" do
      let(:other_block) { proc { :bar } }

      let(:exception_message) do
        <<~TEXT
          Setting a block to null arguments is NOT allowed.

          Consider to create a new arguments object and set block to it instead.
        TEXT
      end

      it "raises `ConvenientService::Support::Arguments::NullArguments::Exceptions::BlockSetIsNotAllowed`" do
        expect { null_arguments.block = other_block }
          .to raise_error(described_class::Exceptions::BlockSetIsNotAllowed)
          .with_message(exception_message)
      end

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      specify do
        expect(ConvenientService).to receive(:raise).and_call_original

        expect { null_arguments.block = other_block }.to raise_error(described_class::Exceptions::BlockSetIsNotAllowed)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    end

    describe "#null_arguments?" do
      it "returns `true`" do
        expect(null_arguments.null_arguments?).to be(true)
      end
    end

    describe "#nil_arguments?" do
      it "returns `true`" do
        expect(null_arguments.nil_arguments?).to be(true)
      end
    end

    describe "#to_arguments" do
      it "returns arguments" do
        expect(null_arguments.to_arguments).to eq(ConvenientService::Support::Arguments.new)
      end

      it "returns NOT null arguments" do
        expect(null_arguments.to_arguments.null_arguments?).to be(false)
      end

      it "does NOT cache its value" do
        expect(null_arguments.to_arguments).not_to equal(null_arguments.to_arguments)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
