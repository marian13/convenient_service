# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#cache_its_value" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      specify do
        expect { instance.cache_its_value }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::CacheItsValue, :new)
          .without_arguments
      end
    end
  end
end
