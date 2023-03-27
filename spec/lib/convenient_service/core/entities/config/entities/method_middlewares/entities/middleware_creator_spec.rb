# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreator do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_creator) { described_class.new(middleware: middleware, arguments: arguments) }
  let(:middleware) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middleware) }
  let(:arguments) { ConvenientService::Support::Arguments.new(:foo, foo: :bar) { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { middleware_creator }

    it { is_expected.to have_attr_reader(:middleware) }
    it { is_expected.to have_attr_reader(:arguments) }
  end

  example_group "instance methods" do
    describe "#new" do
      let(:stack) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack.new }
      let(:env) { {foo: :bar} }
      let(:other_arguments) { ConvenientService::Support::Arguments.new(:foo) }

      it "returns instance of `middleware`" do
        expect(middleware_creator.new(stack, env: env, arguments: other_arguments)).to be_instance_of(middleware)
      end

      context "when `env` is NOT passed" do
        it "defaults to empty hash" do
          expect(middleware_creator.new(stack, arguments: other_arguments).instance_variable_get(:@__env__)).to eq({})
        end
      end

      context "when `arguments` are NOT passed" do
        it "defaults to `self.arguments`" do
          expect(middleware_creator.new(stack, env: env).instance_variable_get(:@__arguments__)).to eq(arguments)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(middleware_creator == other).to be_nil
          end
        end

        context "when `other` has different `middleware`" do
          let(:other) { described_class.new(middleware: Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middleware), arguments: arguments) }

          it "returns `false`" do
            expect(middleware_creator == other).to eq(false)
          end
        end

        context "when `other` has different `arguments`" do
          let(:other) { described_class.new(middleware: middleware, arguments: ConvenientService::Support::Arguments.null_arguments) }

          it "returns `false`" do
            expect(middleware_creator == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(middleware: middleware, arguments: arguments) }

          it "returns `true`" do
            expect(middleware_creator == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
