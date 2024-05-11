# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::PrependModule, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#prepend_module" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:mod) { Module.new }

      specify do
        expect { instance.prepend_module(mod) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::PrependModule, :new)
          .with_arguments(mod)
      end
    end
  end
end
