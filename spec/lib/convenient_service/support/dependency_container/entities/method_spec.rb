# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entities::Method do
  let(:method) { described_class.new(full_name: full_name, scope: scope, body: body) }

  let(:full_name) { :"foo.bar.baz.qux" }
  let(:scope) { :instance }
  let(:body) { proc { :"foo.bar.baz.qux" } }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

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
        let(:name) { :qux }

        context "when `full_name` has namespaces separated by dot" do
          let(:full_name) { :"foo.bar.baz.qux" }

          it "returns last part of `full_name` split by dot" do
            expect(method.name).to eq(name)
          end
        end

        context "when `full_name` has namespaces separated by scope resolution operator" do
          let(:full_name) { :"foo::bar::baz::qux" }

          it "returns last part of `full_name` split by scope resolution operator" do
            expect(method.name).to eq(name)
          end
        end
      end
    end

    describe "#namespace" do
      context "when `full_name` has NO namespaces" do
        let(:full_name) { :foo }

        it "returns empty array" do
          expect(method.namespaces).to eq([])
        end
      end

      context "when `full_name` has namespaces" do
        let(:namespaces) do
          [
            ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :foo),
            ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :bar),
            ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :baz)
          ]
        end

        context "when `full_name` has namespaces separated by dot" do
          let(:full_name) { :"foo.bar.baz.qux" }

          it "returns parts of `full_name` split by dot except last part" do
            expect(method.namespaces).to eq(namespaces)
          end
        end

        context "when `full_name` has namespaces separated by scope resolution operator" do
          let(:full_name) { :"foo::bar::baz::qux" }

          it "returns parts of `full_name` split by scope resolution operator except last part" do
            expect(method.namespaces).to eq(namespaces)
          end
        end
      end
    end

    describe "#define_in_module!" do
      let(:body) { proc { |*args, **kwargs, &block| [args, kwargs, block] } }
      let(:method_return_value) { body.call(*args, **kwargs, &block) }

      let(:user_class) do
        Class.new.tap do |klass|
          klass.class_exec(mod) do |mod|
            include mod
          end
        end
      end

      let(:user_instance) { user_class.new }

      context "when `full_name` has NO namespaces" do
        let(:full_name) { :foo }

        let(:mod) { ConvenientService::Support::DependencyContainer::Commands::CreateMethodsModule.call }

        it "defines `method` in `mod`" do
          method.define_in_module!(mod)

          expect(user_instance.foo(*args, **kwargs, &block)).to eq(method_return_value)
        end

        it "returns `method`" do
          expect(method.define_in_module!(mod)).to eq(method)
        end
      end

      context "when `full_name` has one namespace" do
        let(:full_name) { :"foo.bar" }

        let(:mod) { ConvenientService::Support::DependencyContainer::Commands::CreateMethodsModule.call }

        it "defines `namespace` in `mod`" do
          method.define_in_module!(mod)

          expect(user_instance.foo).to eq(mod.namespaces.find_by(name: :foo))
        end

        it "defines new `namespace` in `mod`" do
          method.define_in_module!(mod)

          expect(user_instance.foo.singleton_methods(false)).to eq([:bar])
        end

        it "defines `method` in `namespace`" do
          method.define_in_module!(mod)

          expect(user_instance.foo.bar(*args, **kwargs, &block)).to eq(method_return_value)
        end

        it "returns `method`" do
          expect(method.define_in_module!(mod)).to eq(method)
        end

        context "when `mod` already has namespace" do
          let(:second_method) { described_class.new(full_name: :"foo.baz", scope: scope, body: body) }

          before do
            second_method.define_in_module!(mod)
          end

          it "reuses that namespace" do
            method.define_in_module!(mod)

            expect(user_instance.foo.singleton_methods(false)).to contain_exactly(:bar, :baz)
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
          let(:other) { described_class.new(full_name: full_name, scope: :class, body: body) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `body`" do
          let(:other) { described_class.new(full_name: full_name, scope: scope, body: proc { :bar }) }

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
