# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::HaveAliasMethod, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#have_alias_method" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:method) { :foo }
      let(:alias_method) { :bar }

      specify do
        expect { instance.have_alias_method(method, alias_method) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::HaveAliasMethod, :new)
          .with_arguments(method, alias_method)
      end
    end
  end
end
