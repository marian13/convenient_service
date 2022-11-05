# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller do
  example_group "constants" do
    describe "::INSTANCE_PREFIX" do
      it "is equal to `\"self.class.\"`" do
        expect(described_class::INSTANCE_PREFIX).to eq("self.class.")
      end
    end

    describe "::CLASS_PREFIX" do
      it "is equal to `\"self.class.\"`" do
        expect(described_class::CLASS_PREFIX).to eq("")
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Concern) }
  end
end
