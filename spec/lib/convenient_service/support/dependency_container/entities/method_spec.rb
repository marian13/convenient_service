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
    describe "#name" do
      context "when `full_name` has NO namespaces" do
        let(:full_name) { :foo }

        it "returns `full_name`" do
          expect(method.name).to eq(method.full_name)
        end
      end

      context "when `full_name` has namespaces" do
        context "when `full_name` has namespaces separated by dot" do
          let(:full_name) { :"foo.bar.baz.qux" }

          it "returns last part of `full_name` split by dot" do
            expect(method.name).to eq(:qux)
          end
        end

        context "when `full_name` has namespaces separated by scope resolution operator" do
          let(:full_name) { :"foo::bar::baz::qux" }

          it "returns last part of `full_name` split by scope resolution operator" do
            expect(method.name).to eq(:qux)
          end
        end
      end
    end

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
