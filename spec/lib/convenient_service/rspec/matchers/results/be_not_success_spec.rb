# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Results::BeNotSuccess do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:instance) { klass.new }

    specify do
      expect { instance.be_not_success }
        .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::BeNotSuccess, :new)
        .without_arguments
        .and_return_its_value
    end
  end
end
