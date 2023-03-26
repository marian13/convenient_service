# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::SymbolValue do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:factory) { described_class.new(other: hash) }
  let(:hash) { {foo: value} }
  let(:value) { :bar }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::Base) }
  end

  example_group "instance methods" do
    describe "#create_key" do
      specify do
        expect { factory.create_key }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key, :new)
          .with_arguments(factory.key)
          .and_return_its_value
      end
    end

    describe "#create_name" do
      specify do
        expect { factory.create_name }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name, :new)
          .with_arguments(factory.value)
          .and_return_its_value
      end
    end

    describe "#create_caller" do
      specify do
        expect { factory.create_caller }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Alias, :new)
          .with_arguments(factory.value)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
