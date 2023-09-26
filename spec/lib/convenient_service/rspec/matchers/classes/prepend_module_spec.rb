# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Classes::PrependModule do
  subject(:matcher_result) { matcher.matches?(klass) }

  let(:matcher) { described_class.new(mod) }

  let(:mod) { Module.new }
  let(:klass) { Class.new }

  describe "#matches?" do
    context "when `klass` does NOT prepend `module`" do
      let(:klass) { Class.new }

      it "returns false" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when `klass` prepends `module`" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(mod) do |mod|
            prepend mod
          end
        end
      end

      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("prepend module `#{mod}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{klass}` to prepend module `#{mod}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{klass}` NOT to prepend module `#{mod}`")
    end
  end
end
