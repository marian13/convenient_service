# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::BeDescendantOf do
  subject(:matcher_result) { matcher.matches?(klass) }

  let(:matcher) { described_class.new(base_klass) }

  let(:base_klass) { Class.new }
  let(:klass) { Class.new }

  describe "#matches?" do
    context "when `klass` is NOT descandant of `base_klass`" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when `klass` is descandant of `base_klass`" do
      let(:klass) { Class.new(base_klass) }

      it "returns `true`" do
        expect(matcher_result).to eq(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("be a descendant of `#{base_klass}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected #{klass} to be a descendant of `#{base_klass}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected #{klass} NOT to be a descendant of `#{base_klass}`")
    end
  end
end
