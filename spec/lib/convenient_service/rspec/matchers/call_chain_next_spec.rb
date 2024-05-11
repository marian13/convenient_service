# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::CallChainNext, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#call_chain_next" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      specify do
        expect { instance.call_chain_next }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::CallChainNext, :new)
          .without_arguments
      end
    end
  end
end
