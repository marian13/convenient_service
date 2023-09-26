# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Hash::Base do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:factory) { described_class.new(other: hash) }
  let(:hash) { {foo: :bar} }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Base) }
  end

  example_group "instance methods" do
    describe "#key" do
      it "returns first key from `hash`" do
        expect(factory.key).to eq(hash.keys.first)
      end

      specify do
        expect { factory.key }.to cache_its_value
      end
    end

    describe "#value" do
      it "returns first value from `hash`" do
        expect(factory.value).to eq(hash.values.first)
      end

      specify do
        expect { factory.value }.to cache_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
