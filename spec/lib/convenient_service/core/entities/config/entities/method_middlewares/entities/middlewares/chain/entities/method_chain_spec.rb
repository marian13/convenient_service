# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Entities::MethodChain, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:chain_result) { chain_instance.next(*args, **kwargs, &block) }
  let(:chain_instance) { described_class.new(stack: stack, env: env) }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }

  let(:env) { {entity: double, method: :result, args: [], kwargs: {}, block: nil} }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#next" do
      specify do
        expect { chain_result }
          .to delegate_to(env, :merge)
          .with_arguments(args: args, kwargs: kwargs, block: block)
      end

      specify do
        expect { chain_result }
          .to delegate_to(stack, :call)
          .with_arguments(env.merge(args: args, kwargs: kwargs, block: block))
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(chain_instance == other).to be_nil
          end
        end

        context "when `other` has different `stack`" do
          let(:other) { described_class.new(stack: ConvenientService::Support::Middleware::StackBuilder.new.use(proc { :foo })) }

          it "returns `false`" do
            expect(chain_instance == other).to eq(false)
          end
        end

        context "when `other` has different `env`" do
          let(:other) { described_class.new(stack: stack, env: {foo: :bar}) }

          it "returns `false`" do
            expect(chain_instance == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(stack: stack, env: env) }

          it "returns `true`" do
            expect(chain_instance == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
