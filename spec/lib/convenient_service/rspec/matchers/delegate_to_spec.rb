# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::DelegateTo do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#delegate_to" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:object) { OpenStruct.new(foo: :bar) }
      let(:method) { :foo }

      specify do
        expect { instance.delegate_to(object, method) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo, :new)
          .with_arguments(object, method)
      end
    end
  end
end
