# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Proc::Display do
  describe ".call" do
    subject(:display) { described_class.call(proc) }

    let(:proc) { -> { :foo } }

    it "returns `{ ... }`" do
      expect(display).to eq("{ ... }")
    end
  end
end
