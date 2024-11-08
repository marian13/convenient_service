# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Classes::IncludeConfig, type: :standard do
  subject(:matcher_result) { matcher.matches?(klass) }

  let(:matcher) { described_class.new(config) }

  let(:klass) { Class.new }

  let(:config) do
    Module.new do
      include ConvenientService::Config
    end
  end

  describe "#matches?" do
    context "when `klass` does NOT include `config`" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when `klass` includes `config`" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(config) do |config|
            include config
          end
        end
      end

      it "returns `true`" do
        expect(matcher_result).to eq(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("include config `#{config.inspect}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{klass.inspect}` to include config `#{config.inspect}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{klass.inspect}` NOT to include config `#{config.inspect}`")
    end
  end
end
