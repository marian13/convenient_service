# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entities::MethodCollection do
  let(:method_collection) { described_class.new(methods: methods) }
  let(:methods) { [method] }
  let(:method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: :instance, body: body) }
  let(:body) { proc { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when `methods` are NOT passed" do
        let(:method_collection) { described_class.new }

        it "defaults to empty array" do
          expect(method_collection.to_a).to eq([])
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#empty?" do
      context "when method collection has NO methods" do
        before do
          method_collection.clear
        end

        it "returns `true`" do
          expect(method_collection.empty?).to eq(true)
        end
      end

      context "when method collection has methods" do
        before do
          method_collection << method
        end

        it "returns `false`" do
          expect(method_collection.empty?).to eq(false)
        end
      end
    end

    describe "#find_by" do
      context "when NO filters are passed" do
        it "returns `nil`" do
          expect(method_collection.find_by).to be_nil
        end
      end

      example_group "`name` filter" do
        let(:method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: name, scope: :instance, body: body) }
        let(:name) { :foo }

        context "when `name` is NOT passed" do
          context "when method collection does NOT have method with `name`" do
            before do
              method_collection.clear
            end

            it "returns `nil`" do
              expect(method_collection.find_by).to be_nil
            end
          end

          context "when method collection has method with `name`" do
            before do
              method_collection << method
            end

            it "returns `nil`" do
              expect(method_collection.find_by).to be_nil
            end
          end
        end

        context "when `name` is passed" do
          context "when method collection does NOT have method with `name`" do
            before do
              method_collection.clear
            end

            it "returns `nil`" do
              expect(method_collection.find_by(name: name)).to be_nil
            end
          end

          context "when method collection has method with `name`" do
            before do
              method_collection << method
            end

            it "returns that method with `name`" do
              expect(method_collection.find_by(name: name)).to eq(method)
            end
          end
        end
      end

      example_group "`slug` filter" do
        let(:method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: slug, scope: :instance, body: body) }
        let(:slug) { :"foo.bar.baz.qux" }

        context "when `slug` is NOT passed" do
          context "when method collection does NOT have method with `slug`" do
            before do
              method_collection.clear
            end

            it "returns `nil`" do
              expect(method_collection.find_by).to be_nil
            end
          end

          context "when method collection has method with `slug`" do
            before do
              method_collection << method
            end

            it "returns `nil`" do
              expect(method_collection.find_by).to be_nil
            end
          end
        end

        context "when `slug` is passed" do
          context "when method collection does NOT have method with `slug`" do
            before do
              method_collection.clear
            end

            it "returns `nil`" do
              expect(method_collection.find_by(slug: slug)).to be_nil
            end
          end

          context "when method collection has method with `slug`" do
            before do
              method_collection << method
            end

            it "returns that method with `slug`" do
              expect(method_collection.find_by(slug: slug)).to eq(method)
            end
          end
        end
      end

      example_group "`scope` filter" do
        let(:method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: scope, body: body) }
        let(:scope) { :class }

        context "when `scope` is NOT passed" do
          context "when method collection does NOT have method with `scope`" do
            before do
              method_collection.clear
            end

            it "returns `nil`" do
              expect(method_collection.find_by).to be_nil
            end
          end

          context "when method collection has method with `scope`" do
            before do
              method_collection << method
            end

            it "returns `nil`" do
              expect(method_collection.find_by).to be_nil
            end
          end
        end

        context "when `scope` is passed" do
          context "when method collection does NOT have method with `scope`" do
            before do
              method_collection.clear
            end

            it "returns `nil`" do
              expect(method_collection.find_by(scope: scope)).to be_nil
            end
          end

          context "when method collection has method with `scope`" do
            before do
              method_collection << method
            end

            it "returns that method with `scope`" do
              expect(method_collection.find_by(scope: scope)).to eq(method)
            end
          end
        end
      end

      context "when multiple filters are passed" do
        context "when method collection does NOT have method that matches those multiple filters" do
          let(:first_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: :instance, body: body) }
          let(:second_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :bar, scope: :instance, body: body) }

          before do
            method_collection << first_method << second_method
          end

          it "returns `nil`" do
            expect(method_collection.find_by(name: :foo, scope: :class)).to be_nil
          end
        end

        context "when method collection has method that matches those multiple filters" do
          let(:first_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: :instance, body: body) }
          let(:second_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: :class, body: body) }

          before do
            method_collection << first_method << second_method
          end

          it "returns that method that matches those multiple filters" do
            expect(method_collection.find_by(name: :foo, scope: :class)).to eq(second_method)
          end
        end
      end

      context "when multiple methods matches filter" do
        let(:first_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: :instance, body: body) }
        let(:second_method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(slug: :foo, scope: :instance, body: body) }

        before do
          method_collection << first_method << second_method
        end

        it "returns first matching method" do
          expect(method_collection.find_by(name: :foo)).to eq(first_method)
        end
      end
    end

    describe "#<<" do
      it "returns self" do
        expect((method_collection << method).object_id).to eq(method_collection.object_id)
      end

      it "appends method to method collection" do
        method_collection << method

        expect(method_collection.include?(method)).to eq(true)
      end
    end

    describe "#include?" do
      context "when method collection does NOT have method" do
        before do
          method_collection.clear
        end

        it "returns `false`" do
          expect(method_collection.include?(method)).to eq(false)
        end
      end

      context "when method collection has method" do
        before do
          method_collection << method
        end

        it "returns `true`" do
          expect(method_collection.include?(method)).to eq(true)
        end
      end
    end

    describe "#clear" do
      it "returns self" do
        expect(method_collection.clear.object_id).to eq(method_collection.object_id)
      end

      context "when method collection has methods" do
        before do
          method_collection << method
        end

        it "clears method collection" do
          method_collection.clear

          expect(method_collection.empty?).to eq(true)
        end
      end
    end

    describe "#to_a" do
      it "returns methods" do
        expect(method_collection.to_a).to eq(methods)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:method_collection) { described_class.new(methods: methods) }
        let(:methods) { [method] }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(method_collection == other).to be_nil
          end
        end

        context "when `other` has different `name`" do
          let(:other) { described_class.new(methods: []) }

          it "returns `false`" do
            expect(method_collection == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(methods: methods) }

          it "returns `true`" do
            expect(method_collection == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
