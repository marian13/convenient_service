# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Hash, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".except" do
    let(:hash) { {foo: "foo", bar: "bar", baz: "baz"} }
    let(:keys) { [:qux] }

    specify do
      expect { described_class.except(hash, keys) }
        .to delegate_to(described_class::Except, :call)
        .with_arguments(hash, keys)
        .and_return_its_value
    end
  end

  describe ".triple_equality_compare" do
    let(:hash) { {foo: (1..10), bar: /bar/} }
    let(:other_hash) { {foo: 5, bar: "bar"} }

    specify do
      expect { described_class.triple_equality_compare(hash, other_hash) }
        .to delegate_to(described_class::TripleEqualityCompare, :call)
        .with_arguments(hash, other_hash)
        .and_return_its_value
    end
  end
end
