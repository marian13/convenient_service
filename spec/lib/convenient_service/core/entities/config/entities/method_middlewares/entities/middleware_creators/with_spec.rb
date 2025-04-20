# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_creator) { described_class.new(middleware: middleware, middleware_arguments: middleware_arguments) }
  let(:middleware) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }
  let(:middleware_arguments) { ConvenientService::Support::Arguments.new(:foo, foo: :bar) { :foo } }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `middleware_arguments` are NOT passed" do
        let(:middleware_creator) { described_class.new(middleware: middleware) }

        it "defaults to null arguments" do
          expect(middleware_creator.middleware_arguments).to eq(ConvenientService::Support::Arguments.null_arguments)
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { middleware_creator }

      it { is_expected.to have_attr_reader(:middleware_arguments) }
    end

    describe "#extra_kwargs" do
      it "returns extra kwargs" do
        expect(middleware_creator.extra_kwargs).to eq({middleware_arguments: middleware_creator.middleware_arguments})
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
          let(:other) { described_class.new(middleware: Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain), middleware_arguments: middleware_arguments) }

          it "returns `false`" do
            expect(middleware_creator == other).to eq(false)
          end
        end

        context "when `other` has different `middleware_arguments`" do
          let(:other) { described_class.new(middleware: middleware, middleware_arguments: ConvenientService::Support::Arguments.null_arguments) }

          it "returns `false`" do
            expect(middleware_creator == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(middleware: middleware, middleware_arguments: middleware_arguments) }

          it "returns `true`" do
            expect(middleware_creator == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
