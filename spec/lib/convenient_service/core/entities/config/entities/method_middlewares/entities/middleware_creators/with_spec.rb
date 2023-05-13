# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_creator) { described_class.new(middleware: middleware, arguments: arguments) }
  let(:middleware) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) }
  let(:arguments) { ConvenientService::Support::Arguments.new(:foo, foo: :bar) { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when `arguments` are NOT passed" do
        let(:middleware_creator) { described_class.new(middleware: middleware) }

        it "defaults to null arguments" do
          expect(middleware_creator.arguments).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { middleware_creator }

      it { is_expected.to have_attr_reader(:arguments) }
    end

    describe "#decorated_middleware" do
      it "returns middleware" do
        expect(middleware_creator.decorated_middleware).to eq(middleware)
      end
    end

    describe "#extra_kwargs" do
      it "returns empty hash" do
        expect(middleware_creator.extra_kwargs).to eq({arguments: middleware_creator.arguments})
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
          let(:other) { described_class.new(middleware: Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain), arguments: arguments) }

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
