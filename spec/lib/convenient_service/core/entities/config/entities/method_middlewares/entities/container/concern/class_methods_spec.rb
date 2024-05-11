# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:container_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        extend mod
      end
    end
  end

  let(:klass) { service_class }
  let(:service_class) { Class.new }
  let(:scope) { :instance }

  example_group "class methods" do
    describe ".cast" do
      let(:other) { {scope: scope, klass: klass} }

      specify do
        expect { container_class.cast(other) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Commands::CastContainer, :call)
          .with_arguments(other: other)
          .and_return_its_value
      end
    end
  end
end
