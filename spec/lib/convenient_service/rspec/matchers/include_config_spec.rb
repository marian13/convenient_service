# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::IncludeConfig, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#include_config" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:config) do
        Module.new do
          include ConvenientService::Config
        end
      end

      specify do
        expect { instance.include_config(config) }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::IncludeConfig, :new)
          .with_arguments(config)
      end
    end
  end
end
