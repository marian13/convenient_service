# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entities::Method do
  let(:method) { described_class.new(full_name: full_name, scope: scope, body: body) }

  let(:full_name) { :"foo.bar.baz.qux" }
  let(:scope) { :class }
  let(:body) { proc { "foo.bar.baz.qux" } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { method }

    it { is_expected.to have_attr_reader(:full_name) }
    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:body) }
  end

  example_group "instance methods" do
    example_group "comparison" do
      describe "#==" do
        let(:method) { described_class.new(full_name: full_name, scope: scope, body: body) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(method == other).to be_nil
          end
        end

        context "when `other` has different `full_name`" do
          let(:other) { described_class.new(full_name: "bar", scope: scope, body: body) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `scope`" do
          let(:other) { described_class.new(full_name: full_name, scope: :instance, body: body) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `body`" do
          let(:other) { described_class.new(full_name: full_name, scope: :instance, body: proc { :bar }) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(full_name: full_name, scope: scope, body: body) }

          it "returns `true`" do
            expect(method == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
