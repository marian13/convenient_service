# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Hash, type: :standard do
  describe ".except" do
    let(:hash) { {foo: "foo", bar: "bar", baz: "baz"} }
    let(:keys) { [:qux] }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Hash::Except.call`" do
      expect(described_class::Except)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[hash, keys], {}, nil]) }

      described_class.except(hash, keys)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Hash::Except.call` value" do
      expect(described_class.except(hash, keys)).to eq(described_class::Except.call(hash, keys))
    end
  end

  describe ".triple_equality_compare" do
    let(:hash) { {foo: (1..10), bar: /bar/} }
    let(:other_hash) { {foo: 5, bar: "bar"} }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Hash::TripleEqualityCompare.call`" do
      expect(described_class::TripleEqualityCompare)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[hash, other_hash], {}, nil]) }

      described_class.triple_equality_compare(hash, other_hash)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Hash::TripleEqualityCompare.call` value" do
      expect(described_class.triple_equality_compare(hash, other_hash)).to eq(described_class::TripleEqualityCompare.call(hash, other_hash))
    end
  end
end
