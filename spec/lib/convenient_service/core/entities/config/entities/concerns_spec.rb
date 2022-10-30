# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::Concerns do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:concerns) { described_class.new(entity: entity) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:service_instance) { service_class.new }

  let(:entity) { service_class }

  let(:concern) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def foo(*args, **kwargs, &block)
          [:foo, args, kwargs, block&.source_location]
        end
      end
    end
  end

  let(:foo_value) { [:foo, args, kwargs, block&.source_location] }

  let(:other_concern) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def bar(*args, **kwargs, &block)
          [:bar, args, kwargs, block&.source_location]
        end
      end
    end
  end

  let(:bar_value) { [:bar, args, kwargs, block&.source_location] }

  example_group "instance methods" do
    let(:module_with_instance_method) do
      Module.new do
        def result
        end
      end
    end

    let(:module_with_private_instance_method) do
      Module.new do
        private

        def result
        end
      end
    end

    let(:other_module_with_instance_method) do
      Module.new do
        def result
        end
      end
    end

    let(:other_module_with_private_instance_method) do
      Module.new do
        private

        def result
        end
      end
    end

    let(:concern_with_instance_method) do
      Module.new do
        include ConvenientService::Support::Concern

        instance_methods do
          def result
          end
        end
      end
    end

    let(:concern_with_private_instance_method) do
      Module.new do
        include ConvenientService::Support::Concern

        instance_methods do
          private

          def result
          end
        end
      end
    end

    let(:concern_with_class_method) do
      Module.new do
        include ConvenientService::Support::Concern

        class_methods do
          def result
          end
        end
      end
    end

    let(:concern_with_private_class_method) do
      Module.new do
        include ConvenientService::Support::Concern

        class_methods do
          private

          def result
          end
        end
      end
    end

    let(:other_concern_with_instance_method) do
      Module.new do
        include ConvenientService::Support::Concern

        instance_methods do
          def result
          end
        end
      end
    end

    let(:other_concern_with_private_instance_method) do
      Module.new do
        include ConvenientService::Support::Concern

        instance_methods do
          private

          def result
          end
        end
      end
    end

    let(:other_concern_with_class_method) do
      Module.new do
        include ConvenientService::Support::Concern

        class_methods do
          def result
          end
        end
      end
    end

    let(:other_concern_with_private_class_method) do
      Module.new do
        include ConvenientService::Support::Concern

        class_methods do
          private

          def result
          end
        end
      end
    end

    let(:module_without_instance_method) { Module.new }
    let(:module_without_private_instance_method) { Module.new }

    let(:other_module_without_instance_method) { Module.new }
    let(:other_module_without_private_instance_method) { Module.new }

    let(:concern_without_instance_method) { Module.new { include ConvenientService::Support::Concern } }
    let(:concern_without_private_instance_method) { Module.new { include ConvenientService::Support::Concern } }

    let(:concern_without_class_method) { Module.new { include ConvenientService::Support::Concern } }
    let(:concern_without_private_class_method) { Module.new { include ConvenientService::Support::Concern } }

    let(:other_concern_without_instance_method) { Module.new { include ConvenientService::Support::Concern } }
    let(:other_concern_without_private_instance_method) { Module.new { include ConvenientService::Support::Concern } }

    let(:other_concern_without_class_method) { Module.new { include ConvenientService::Support::Concern } }
    let(:other_concern_without_private_class_method) { Module.new { include ConvenientService::Support::Concern } }

    describe "#instance_method_defined?" do
      context "when concerns do NOT have any module or concern with instance method" do
        before do
          concerns.configure {}
        end

        it "returns `false`" do
          expect(concerns.instance_method_defined?(:result)).to eq(false)
        end
      end

      context "when concerns has one module with instance method" do
        before do
          concerns.configure do |stack|
            stack.use module_with_instance_method
          end
        end

        it "returns `true`" do
          expect(concerns.instance_method_defined?(:result)).to eq(true)
        end
      end

      context "when concerns has one concern with instance method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_instance_method
          end
        end

        it "returns `true`" do
          expect(concerns.instance_method_defined?(:result)).to eq(true)
        end
      end

      context "when concerns has multiple modules" do
        context "when none one of those modules has instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_without_instance_method
              stack.use other_module_without_instance_method
            end
          end

          it "returns `false`" do
            expect(concerns.instance_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those modules has instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_with_instance_method
              stack.use other_module_without_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.instance_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has multiple concerns" do
        context "when none one of those concerns has instance method" do
          before do
            concerns.configure do |stack|
              stack.use concern_without_instance_method
              stack.use other_concern_without_instance_method
            end
          end

          it "returns `false`" do
            expect(concerns.instance_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those concerns has instance method" do
          before do
            concerns.configure do |stack|
              stack.use concern_with_instance_method
              stack.use other_concern_without_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.instance_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has both modules and concerns" do
        context "when none one of those modules and concerns has instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_without_instance_method
              stack.use concern_without_instance_method
            end
          end

          it "returns `false`" do
            expect(concerns.instance_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those modules has instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_with_instance_method
              stack.use concern_without_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.instance_method_defined?(:result)).to eq(true)
          end
        end

        context "when at least one of those concerns has instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_without_instance_method
              stack.use concern_with_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.instance_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has module with private instance method" do
        before do
          concerns.configure do |stack|
            stack.use module_with_private_instance_method
          end
        end

        it "returns `false`" do
          expect(concerns.instance_method_defined?(:result)).to eq(false)
        end
      end

      context "when concerns has concern with private instance method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_private_instance_method
          end
        end

        it "returns `false`" do
          expect(concerns.instance_method_defined?(:result)).to eq(false)
        end
      end
    end

    describe "#private_instance_method_defined?" do
      context "when concerns do NOT have any module or concern with private instance method" do
        before do
          concerns.configure {}
        end

        it "returns `false`" do
          expect(concerns.private_instance_method_defined?(:result)).to eq(false)
        end
      end

      context "when concerns has one module with instance method" do
        before do
          concerns.configure do |stack|
            stack.use module_with_private_instance_method
          end
        end

        it "returns `true`" do
          expect(concerns.private_instance_method_defined?(:result)).to eq(true)
        end
      end

      context "when concerns has one concern with private instance method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_private_instance_method
          end
        end

        it "returns `true`" do
          expect(concerns.private_instance_method_defined?(:result)).to eq(true)
        end
      end

      context "when concerns has multiple modules" do
        context "when none one of those modules has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_without_private_instance_method
              stack.use other_module_without_private_instance_method
            end
          end

          it "returns `false`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those modules has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_with_private_instance_method
              stack.use other_module_without_private_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has multiple concerns" do
        context "when none one of those concerns has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use concern_without_private_instance_method
              stack.use other_concern_without_private_instance_method
            end
          end

          it "returns `false`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those concerns has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use concern_with_private_instance_method
              stack.use other_concern_without_private_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has both modules and concerns" do
        context "when none one of those modules and concerns has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_without_private_instance_method
              stack.use concern_without_private_instance_method
            end
          end

          it "returns `false`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those modules has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_with_private_instance_method
              stack.use concern_without_private_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(true)
          end
        end

        context "when at least one of those concerns has private instance method" do
          before do
            concerns.configure do |stack|
              stack.use module_without_private_instance_method
              stack.use concern_with_private_instance_method
            end
          end

          it "returns `true`" do
            expect(concerns.private_instance_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has module with instance method" do
        before do
          concerns.configure do |stack|
            stack.use module_with_instance_method
          end
        end

        it "returns `false`" do
          expect(concerns.private_instance_method_defined?(:result)).to eq(false)
        end
      end

      context "when concerns has concern with instance method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_instance_method
          end
        end

        it "returns `false`" do
          expect(concerns.private_instance_method_defined?(:result)).to eq(false)
        end
      end
    end

    describe "#class_method_defined?" do
      context "when concerns do NOT have concern with class method" do
        before do
          concerns.configure {}
        end

        it "returns `false`" do
          expect(concerns.class_method_defined?(:result)).to eq(false)
        end
      end

      context "when concerns has one concern with class method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_class_method
          end
        end

        it "returns `true`" do
          expect(concerns.class_method_defined?(:result)).to eq(true)
        end
      end

      context "when concerns has multiple concerns" do
        context "when none one of those concerns has class method" do
          before do
            concerns.configure do |stack|
              stack.use concern_without_class_method
              stack.use other_concern_without_class_method
            end
          end

          it "returns `false`" do
            expect(concerns.class_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those concerns has class method" do
          before do
            concerns.configure do |stack|
              stack.use concern_with_class_method
              stack.use other_concern_without_class_method
            end
          end

          it "returns `true`" do
            expect(concerns.class_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has concern with private class method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_private_class_method
          end
        end

        it "returns `false`" do
          expect(concerns.class_method_defined?(:result)).to eq(false)
        end
      end
    end

    describe "#private_class_method_defined?" do
      context "when concerns do NOT have concern with private class method" do
        before do
          concerns.configure {}
        end

        it "returns `false`" do
          expect(concerns.private_class_method_defined?(:result)).to eq(false)
        end
      end

      context "when concerns has one concern with private class method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_private_class_method
          end
        end

        it "returns `true`" do
          expect(concerns.private_class_method_defined?(:result)).to eq(true)
        end
      end

      context "when concerns has multiple concerns" do
        context "when none one of those concerns has private class method" do
          before do
            concerns.configure do |stack|
              stack.use concern_without_private_class_method
              stack.use other_concern_without_private_class_method
            end
          end

          it "returns `false`" do
            expect(concerns.private_class_method_defined?(:result)).to eq(false)
          end
        end

        context "when at least one of those concerns has private class method" do
          before do
            concerns.configure do |stack|
              stack.use concern_with_private_class_method
              stack.use other_concern_without_private_class_method
            end
          end

          it "returns `true`" do
            expect(concerns.private_class_method_defined?(:result)).to eq(true)
          end
        end
      end

      context "when concerns has concern with class method" do
        before do
          concerns.configure do |stack|
            stack.use concern_with_class_method
          end
        end

        it "returns `false`" do
          expect(concerns.private_class_method_defined?(:result)).to eq(false)
        end
      end
    end

    describe "#configure" do
      context "when `configuration_block` does NOT have one argument" do
        ##
        # NOTE: Calls `use` that is defined in stack.
        #
        let(:configuration_block) do
          proc do
            concern = Module.new do
              include ConvenientService::Support::Concern

              instance_methods do
                def foo(*args, **kwargs, &block)
                  [:foo, args, kwargs, block&.source_location]
                end
              end
            end

            use concern
          end
        end

        it "executes `configuration_block` in stack context" do
          expect { concerns.configure(&configuration_block) }.not_to raise_error
        end

        it "configures stack" do
          concerns.configure(&configuration_block)

          concerns.include!

          ##
          # NOTE: If stack is configured correctly then `foo` method exists in service class. See how concerns are defined.
          #
          expect(service_instance.foo(*args, **kwargs, &block)).to eq(foo_value)
        end

        it "returns concerns" do
          expect(concerns.configure(&configuration_block)).to eq(concerns)
        end
      end

      context "when `configuration_block` has one argument" do
        let(:concern) do
          Module.new do
            include ConvenientService::Support::Concern

            instance_methods do
              def foo(*args, **kwargs, &block)
                [:foo, args, kwargs, block&.source_location]
              end
            end
          end
        end

        ##
        # NOTE: Calls `concern` that is defined in the enclosing context.
        #
        let(:configuration_block) { proc { |stack| stack.use concern } }

        it "executes `configuration_block` in enclosing context" do
          expect { concerns.configure(&configuration_block) }.not_to raise_error
        end

        it "configures stack" do
          concerns.configure(&configuration_block)

          concerns.include!

          ##
          # NOTE: If stack is configured correctly then `foo` method exists in service class. See how concerns are defined.
          #
          expect(service_instance.foo(*args, **kwargs, &block)).to eq(foo_value)
        end

        it "returns concerns" do
          expect(concerns.configure(&configuration_block)).to eq(concerns)
        end
      end
    end

    ##
    # TODO: Specs.
    #
    # describe "#include!" do
    # end
    #
    # describe "#included?" do
    # end
    #
    describe "#to_a" do
      context "when stack is NOT empty" do
        it "returns concerns" do
          concerns.configure do |stack|
            stack.use concern
            stack.use other_concern
          end

          expect(concerns.to_a).to eq([concern, other_concern])
        end
      end

      context "when stack is empty" do
        it "returns empty array" do
          expect(concerns.to_a).to eq([])
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:concerns) { described_class.new(entity: entity) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(concerns == other).to be_nil
          end
        end

        context "when `other` has different `entity`" do
          let(:other) { described_class.new(entity: Class.new) }

          it "returns `false`" do
            expect(concerns == other).to eq(false)
          end
        end

        context "when `other` has different `stack`" do
          let(:other) { described_class.new(entity: entity).configure { |stack| stack.use concern } }

          it "returns `false`" do
            expect(concerns == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(entity: entity) }

          it "returns `true`" do
            expect(concerns == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
