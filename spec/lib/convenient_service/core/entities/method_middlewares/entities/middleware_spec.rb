# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_result) { middleware_instance.call(env) }
  let(:middleware_instance) { middleware_class.new(stack) }

  let(:middleware_class) do
    Class.new(described_class) do
      def next(...)
        chain.next(...)
      end
    end
  end

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: double, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "abstract methods" do
    include ConvenientService::RSpec::Matchers::HaveAbstractMethod

    subject { described_class.new(stack) }

    it { is_expected.to have_abstract_method(:next) }
  end

  example_group "instance_methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::CacheItsValue

    describe "#call" do
      it "sets middleware @env instance variable to `env`" do
        expect { middleware_result }.to change { middleware_instance.instance_variable_get(:@env) }.from({}).to(env)
      end

      it "sets middleware chain @env instance variable to `env`" do
        expect { middleware_result }.to change { middleware_instance.chain.instance_variable_get(:@env) }.from({}).to(env)
      end

      specify do
        expect { middleware_result }
          .to delegate_to(middleware_instance, :next)
          .with_arguments(*env[:args], **env[:kwargs], &env[:block])
          .and_return_its_value
      end
    end

    describe "#env" do
      context "when middleware is NOT called" do
        it "returns `nil`" do
          expect(middleware_instance.entity).to eq(nil)
        end
      end

      context "when middleware is called" do
        it "returns `env[:entity]" do
          middleware_result

          expect(middleware_instance.entity).to eq(env[:entity])
        end
      end
    end

    describe "#method" do
      context "when middleware is NOT called" do
        it "returns `nil`" do
          expect(middleware_instance.method).to eq(nil)
        end
      end

      context "when middleware is called" do
        it "returns `env[:method]" do
          middleware_result

          expect(middleware_instance.method).to eq(env[:method])
        end
      end
    end

    describe "#chain" do
      it "returns chain" do
        expect(middleware_instance.chain).to eq(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Chain.new(stack: stack))
      end

      specify { expect { middleware_instance.chain }.to cache_its_value }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
