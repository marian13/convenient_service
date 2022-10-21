# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Concerns do
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
    ##
    # TODO: Specs.
    #
    # describe "#instance_method_defined?" do
    # end
    #
    # describe "#private_instance_method_defined?" do
    # end
    #
    # describe "#class_method_defined?" do
    # end
    #
    # describe "#private_class_method_defined?" do
    # end
    #
    # describe "#assert_not_included!" do
    # end
    #
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
