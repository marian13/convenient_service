# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Custom::Export do
  subject(:matcher_result) { matcher.matches?(container) }

  let(:matcher) { described_class.new(method_name, scope: scope) }

  let(:mod) { ConvenientService::Support::DependencyContainer::Export }
  let(:method_name) { :bar }
  let(:scope) { :class }

  let(:container) do
    Class.new.tap do |klass|
      klass.class_exec(mod) do |mod|
        include mod

        export :bar, scope: :class do
          ":bar with scope: :class"
        end
      end
    end
  end

  describe "#matches?" do
    context "when `container` does NOT export method" do
      let(:method_name) { :bar }
      let(:scope) { :class }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(mod) do |mod|
            include mod
          end
        end
      end

      it "returns false" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when `container` exports method but with `instance` scope" do
      let(:method_name) { :foo }
      let(:scope) { :class }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(mod) do |mod|
            include mod

            export :foo do
              ":foo with scope: :instance"
            end
          end
        end
      end

      it "returns false" do
        expect(matcher_result).to eq(false)
      end
    end

    context "when `container` exports method without given scope" do
      let(:matcher) { described_class.new(method_name) }

      let(:method_name) { :foo }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(mod) do |mod|
            include mod

            export :foo do
              ":foo with scope: :instance"
            end
          end
        end
      end

      it "returns true" do
        expect(matcher_result).to eq(true)
      end
    end

    context "when `container` exports method" do
      let(:method_name) { :foo }
      let(:scope) { :class }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(mod) do |mod|
            include mod

            export :foo, scope: :class do
              ":foo with scope: :class"
            end
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

      expect(matcher.description).to eq("export `#{method_name}` with scope `#{scope}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{container.class}` to have exported `#{method_name}` with scope `#{scope}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{container.class}` NOT to have exported `#{method_name}` with scope `#{scope}`")
    end
  end
end
