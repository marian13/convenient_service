# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection, type: :standard do
  let(:namespace_collection) { described_class.new(namespaces: namespaces) }
  let(:namespaces) { [namespace] }
  let(:namespace) { ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :foo) }
  let(:body) { proc { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when `namespaces` are NOT passed" do
        let(:namespace_collection) { described_class.new }

        it "defaults to empty array" do
          expect(namespace_collection.to_a).to eq([])
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#empty?" do
      context "when namespace collection has NO namespaces" do
        before do
          namespace_collection.clear
        end

        it "returns `true`" do
          expect(namespace_collection.empty?).to be(true)
        end
      end

      context "when namespace collection has namespaces" do
        before do
          namespace_collection << namespace
        end

        it "returns `false`" do
          expect(namespace_collection.empty?).to be(false)
        end
      end
    end

    describe "#find_by" do
      context "when NO filters are passed" do
        it "returns `nil`" do
          expect(namespace_collection.find_by).to be_nil
        end
      end

      example_group "`name` filter" do
        let(:namespace) { ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: name) }
        let(:name) { :foo }

        context "when `name` is NOT passed" do
          context "when namespace collection does NOT have namespace with `name`" do
            before do
              namespace_collection.clear
            end

            it "returns `nil`" do
              expect(namespace_collection.find_by).to be_nil
            end
          end

          context "when namespace collection has namespace with `name`" do
            before do
              namespace_collection << namespace
            end

            it "returns `nil`" do
              expect(namespace_collection.find_by).to be_nil
            end
          end
        end

        context "when `name` is passed" do
          context "when namespace collection does NOT have namespace with `name`" do
            before do
              namespace_collection.clear
            end

            it "returns `nil`" do
              expect(namespace_collection.find_by(name: name)).to be_nil
            end
          end

          context "when namespace collection has namespace with `name`" do
            before do
              namespace_collection << namespace
            end

            it "returns that namespace with `name`" do
              expect(namespace_collection.find_by(name: name)).to eq(namespace)
            end
          end
        end
      end
    end

    describe "#<<" do
      it "returns self" do
        expect(namespace_collection << namespace).to equal(namespace_collection)
      end

      it "appends namespace to namespace collection" do
        namespace_collection << namespace

        expect(namespace_collection.include?(namespace)).to be(true)
      end
    end

    describe "#include?" do
      context "when namespace collection does NOT have namespace" do
        before do
          namespace_collection.clear
        end

        it "returns `false`" do
          expect(namespace_collection.include?(namespace)).to be(false)
        end
      end

      context "when namespace collection has namespace" do
        before do
          namespace_collection << namespace
        end

        it "returns `true`" do
          expect(namespace_collection.include?(namespace)).to be(true)
        end
      end
    end

    describe "#clear" do
      it "returns self" do
        expect(namespace_collection.clear).to equal(namespace_collection)
      end

      context "when namespace collection has namespaces" do
        before do
          namespace_collection << namespace
        end

        it "clears namespace collection" do
          namespace_collection.clear

          expect(namespace_collection.empty?).to be(true)
        end
      end
    end

    describe "#to_a" do
      it "returns namespaces" do
        expect(namespace_collection.to_a).to eq(namespaces)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:namespace_collection) { described_class.new(namespaces: namespaces) }
        let(:namespaces) { [namespace] }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(namespace_collection == other).to be_nil
          end
        end

        context "when `other` has different `name`" do
          let(:other) { described_class.new(namespaces: []) }

          it "returns `false`" do
            expect(namespace_collection == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(namespaces: namespaces) }

          it "returns `true`" do
            expect(namespace_collection == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
