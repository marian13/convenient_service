# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::HaveAttrWriter, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#have_attr_writer" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:method) { :foo }

      specify do
        expect { instance.have_attr_writer(method) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::HaveAttrWriter, :new)
          .with_arguments(method)
      end
    end
  end
end
