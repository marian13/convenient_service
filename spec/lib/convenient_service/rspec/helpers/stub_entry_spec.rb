# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::StubEntry, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:instance) { klass.new }

    describe "#stub_entry" do
      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          entry :main

          def main
            :main_entry_value
          end
        end
      end

      let(:entry_name) { :main }

      specify do
        expect { instance.stub_entry(feature_class, entry_name) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubEntry, :call)
          .with_arguments(feature_class, entry_name)
          .and_return_its_value
      end
    end

    describe "#return_value" do
      let(:value) { 42 }

      specify do
        expect { instance.return_value(value) }
          .to delegate_to(ConvenientService::RSpec::Helpers::Classes::StubEntry::Entities::ValueSpec, :new)
          .with_arguments(value: value)
          .and_return_its_value
      end
    end
  end
end
