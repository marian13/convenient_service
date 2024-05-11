# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        extend mod
      end
    end
  end

  let(:scope) { :instance }

  example_group "class methods" do
    describe ".cast" do
      let(:other) { {scope: scope} }

      specify do
        expect { caller_class.cast(other) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::CastCaller, :call)
          .with_arguments(other: other)
          .and_return_its_value
      end
    end
  end
end
