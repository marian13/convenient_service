# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Constants, type: :standard do
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
end
