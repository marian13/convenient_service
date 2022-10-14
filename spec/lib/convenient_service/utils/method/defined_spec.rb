# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Method::Defined do
  describe ".defined?" do
    let(:method) { :foo }

    context "when `class` does NOT have `method`" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(described_class.call(method, klass)).to eq(false)
      end
    end

    context "when `class` has `method`" do
      context "when that `method` is `public`" do
        let(:klass) do
          Class.new do
            def foo
            end
          end
        end

        it "returns `true`" do
          expect(described_class.call(method, klass)).to eq(true)
        end
      end

      context "when that `method` is `protected`" do
        let(:klass) do
          Class.new do
            protected

            def foo
            end
          end
        end

        it "returns `true`" do
          expect(described_class.call(method, klass)).to eq(true)
        end
      end

      context "when that `method` is `private`" do
        let(:klass) do
          Class.new do
            private

            def foo
            end
          end
        end

        context "when `private` is false" do
          it "returns `false`" do
            expect(described_class.call(method, klass, private: false)).to eq(false)
          end
        end

        context "when `private` is true" do
          it "returns `true`" do
            expect(described_class.call(method, klass, private: true)).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
