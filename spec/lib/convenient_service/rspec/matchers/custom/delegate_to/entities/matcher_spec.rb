# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher do
  let(:matcher) { described_class.new(object: object, method: method) }

  let(:klass) do
    Class.new do
      def foo
        bar
      end

      def bar
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }

  let(:printable_method) { "#{klass}##{method}" }

  example_group "instance methods" do
    describe "#printable_method" do
      context "when `object` is class" do
        let(:object) do
          Class.new do
            def self.bar
            end
          end
        end

        let(:method) { :bar }

        it "returns string in 'class.method' format" do
          expect(matcher.printable_method).to eq("#{object}.#{method}")
        end
      end

      context "when `object` is module" do
        let(:object) do
          Module.new do
            def self.bar
            end
          end
        end

        let(:method) { :bar }

        it "returns string in 'module.method' format" do
          expect(matcher.printable_method).to eq("#{object}.#{method}")
        end
      end

      context "when `object` is instance" do
        let(:klass) do
          Class.new do
            def bar
            end
          end
        end

        let(:object) { klass.new }
        let(:method) { :bar }

        it "returns string in 'class#method' format" do
          expect(matcher.printable_method).to eq("#{klass}##{method}")
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
