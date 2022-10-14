# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Hash do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".except" do
    let(:hash) { {foo: "foo", bar: "bar", baz: "baz"} }
    let(:keys) { [:qux] }

    specify do
      expect { described_class.except(hash, keys) }
        .to delegate_to(ConvenientService::Utils::Hash::Except, :call)
        .with_arguments(hash, keys)
        .and_return_its_value
    end
  end
end
