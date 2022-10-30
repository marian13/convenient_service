# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Concerns::Entities::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_result) { middleware_instance.call(env) }
  let(:middleware_instance) { middleware_class.new(stack) }
  let(:middleware_class) { described_class.cast(mod) }

  let(:mod) { Module.new }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {entity: entity, method: :result, args: args, kwargs: kwargs, block: block} }

  let(:entity) { Class.new }
  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to extend_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "class abstract methods" do
    include ConvenientService::RSpec::Matchers::HaveAbstractMethod

    subject { described_class }

    it { is_expected.to have_abstract_method(:concern) }
  end

  example_group "class methods" do
    describe ".original_two_equals" do
      context "when other is NOT `ConvenientService::Core::Entities::Concerns::Entities::Middleware`" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(described_class.original_two_equals(other)).to eq(false)
        end
      end

      context "when other is `ConvenientService::Core::Entities::Concerns::Entities::Middleware`" do
        let(:other) { described_class }

        it "returns `true`" do
          expect(described_class.original_two_equals(other)).to eq(true)
        end
      end

      context "when other is `ConvenientService::Core::Entities::Concerns::Entities::Middleware` descendant" do
        let(:other) do
          ::Class.new(described_class).tap do |klass|
            klass.class_exec(Module.new) do |mod|
              define_singleton_method(:concern) { mod }
            end
          end
        end

        it "returns `false`" do
          expect(described_class.original_two_equals(other)).to eq(false)
        end
      end
    end

    describe ".==" do
      context "when other is NOT `ConvenientService::Core::Entities::Concerns::Entities::Middleware`" do
        context "when other is NOT instance of Class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(described_class == other).to eq(nil)
          end
        end

        context "when other is instance of Class" do
          context "when that Class is NOT `ConvenientService::Core::Entities::Concerns::Entities::Middleware` descendant" do
            let(:other) { Class.new }

            it "returns `nil`" do
              expect(described_class == other).to eq(nil)
            end
          end

          context "when that Class is `ConvenientService::Core::Entities::Concerns::Entities::Middleware` descendant" do
            let(:other) do
              ::Class.new(described_class).tap do |klass|
                klass.class_exec(Module.new) do |mod|
                  define_singleton_method(:concern) { mod }
                end
              end
            end

            let(:error_message) do
              <<~TEXT
                `#{described_class}` should implement abstract class method `concern`.
              TEXT
            end

            it "raises `ConvenientService::Support::AbstractMethod::Errors::AbstractMethodNotOverridden`" do
              expect { described_class == other }
                .to raise_error(ConvenientService::Support::AbstractMethod::Errors::AbstractMethodNotOverridden)
                .with_message(error_message)
            end
          end
        end
      end

      context "when other is `ConvenientService::Core::Entities::Concerns::Entities::Middleware`" do
        let(:other) { described_class }

        it "returns `true`" do
          expect(described_class == other).to eq(true)
        end
      end
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#call" do
      it "includes `mod` to `env[:entity]`" do
        expect { middleware_result }.to change { entity.include?(mod) }.from(false).to(true)
      end

      specify do
        expect { middleware_result }
          .to delegate_to(stack, :call)
          .with_arguments(env)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
