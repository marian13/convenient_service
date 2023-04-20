# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entities::Method do
  let(:method) { described_class.new(slug: slug, scope: scope, body: body, alias_slug: alias_slug) }

  let(:slug) { :"foo.bar.baz.qux" }
  let(:scope) { :instance }
  let(:body) { proc { :"foo.bar.baz.qux" } }
  let(:alias_slug) { nil }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { method }

    it { is_expected.to have_attr_reader(:slug) }
    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:body) }
    it { is_expected.to have_attr_reader(:alias_slug) }
  end

  example_group "instance methods" do
    describe "#import_name" do
      context "when `alias_slug` is passed" do
        let(:alias_slug) { :bar }

        it "returns `alias_slug`" do
          expect(method.import_name).to eq(method.alias_slug)
        end
      end

      context "when `alias_slug` is NOT passed" do
        it "returns `slug`" do
          expect(method.import_name).to eq(method.slug)
        end
      end
    end

    describe "#name" do
      context "when `slug` has NO namespaces" do
        let(:slug) { :foo }

        it "returns `slug`" do
          expect(method.name).to eq(method.slug)
        end
      end

      context "when `slug` has namespaces" do
        let(:name) { :qux }

        context "when `slug` has namespaces separated by dot" do
          let(:slug) { :"foo.bar.baz.qux" }

          it "returns last part of `slug` split by dot" do
            expect(method.name).to eq(name)
          end
        end

        context "when `slug` has namespaces separated by scope resolution operator" do
          let(:slug) { :"foo::bar::baz::qux" }

          it "returns last part of `slug` split by scope resolution operator" do
            expect(method.name).to eq(name)
          end
        end
      end
    end

    describe "#namespace" do
      context "when `slug` has NO namespaces" do
        let(:slug) { :foo }

        it "returns empty array" do
          expect(method.namespaces).to eq([])
        end
      end

      context "when `slug` has namespaces" do
        let(:namespaces) do
          [
            ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :foo),
            ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :bar),
            ConvenientService::Support::DependencyContainer::Entities::Namespace.new(name: :baz)
          ]
        end

        context "when `slug` has namespaces separated by dot" do
          let(:slug) { :"foo.bar.baz.qux" }

          it "returns parts of `slug` split by dot except last part" do
            expect(method.namespaces).to eq(namespaces)
          end
        end

        context "when `slug` has namespaces separated by scope resolution operator" do
          let(:slug) { :"foo::bar::baz::qux" }

          it "returns parts of `slug` split by scope resolution operator except last part" do
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

      context "when `slug` has NO namespaces" do
        let(:slug) { :foo }

        let(:mod) { ConvenientService::Support::DependencyContainer::Commands::CreateMethodsModule.call }

        it "defines `method` in `mod`" do
          method.define_in_module!(mod)

          expect(user_instance.foo(*args, **kwargs, &block)).to eq(method_return_value)
        end

        it "returns `method`" do
          expect(method.define_in_module!(mod)).to eq(method)
        end
      end

      context "when `slug` has one namespace" do
        let(:slug) { :"foo.bar" }

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
          let(:second_method) { described_class.new(slug: :"foo.baz", scope: scope, body: body) }

          before do
            second_method.define_in_module!(mod)
          end

          it "reuses that namespace" do
            method.define_in_module!(mod)

            expect(user_instance.foo.singleton_methods(false)).to contain_exactly(:bar, :baz)
          end
        end
      end

      context "when `slug` has multiple namespaces" do
        let(:slug) { :"foo.bar.baz" }

        let(:mod) { ConvenientService::Support::DependencyContainer::Commands::CreateMethodsModule.call }

        it "defines outer `namespace` in `mod`" do
          method.define_in_module!(mod)

          expect(user_instance.foo).to eq(mod.namespaces.find_by(name: :foo))
        end

        it "defines new outer `namespace` in `mod`" do
          method.define_in_module!(mod)

          expect(user_instance.foo.singleton_methods(false)).to eq([:bar])
        end

        it "defines inner `namespace` in outer `namespace`" do
          method.define_in_module!(mod)

          expect(user_instance.foo.bar).to eq(mod.namespaces.find_by(name: :foo).namespaces.find_by(name: :bar))
        end

        it "defines `method` in inner `namespace`" do
          method.define_in_module!(mod)

          expect(user_instance.foo.bar.baz(*args, **kwargs, &block)).to eq(method_return_value)
        end

        it "returns `method`" do
          expect(method.define_in_module!(mod)).to eq(method)
        end

        context "when `mod` already has outer namespace" do
          let(:second_method) { described_class.new(slug: :"foo.baz", scope: scope, body: body) }

          before do
            second_method.define_in_module!(mod)
          end

          it "reuses that outer namespace" do
            method.define_in_module!(mod)

            expect(user_instance.foo.singleton_methods(false)).to contain_exactly(:bar, :baz)
          end

          context "when outer namespace already has inner namespace" do
            let(:second_method) { described_class.new(slug: :"foo.bar.qux", scope: scope, body: body) }

            before do
              second_method.define_in_module!(mod)
            end

            it "reuses that inner namespace" do
              method.define_in_module!(mod)

              expect(user_instance.foo.bar.singleton_methods(false)).to contain_exactly(:baz, :qux)
            end
          end
        end
      end

      describe "#to_kwargs" do
        let(:kwargs) do
          {
            slug: slug,
            scope: scope,
            body: body,
            alias_slug: alias_slug
          }
        end

        it "returns true" do
          expect(method.to_kwargs).to eq(kwargs)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:method) { described_class.new(slug: slug, scope: scope, body: body) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(method == other).to be_nil
          end
        end

        context "when `other` has different `slug`" do
          let(:other) { described_class.new(slug: "bar", scope: scope, body: body) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `scope`" do
          let(:other) { described_class.new(slug: slug, scope: :class, body: body) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `body`" do
          let(:other) { described_class.new(slug: slug, scope: scope, body: proc { :bar }) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `alias_slug`" do
          let(:other) { described_class.new(slug: slug, scope: scope, body: proc { :bar }, alias_slug: :bar) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(slug: slug, scope: scope, body: body) }

          it "returns `true`" do
            expect(method == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
