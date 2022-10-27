# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Caller do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { caller_class.new(container: container) }
  let(:caller_class) { described_class }

  let(:entity) { double }
  let(:method_name) { :result }

  let(:container) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }

  let(:service_instance) { service_class.new }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:klass) { service_class }

  let(:concern) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def result
        end
      end

      class_methods do
        def result
        end
      end
    end
  end

  let(:other_concern) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def result
        end
      end

      class_methods do
        def result
        end
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { caller }

    it { is_expected.to have_attr_reader(:container) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { caller }
  #
  #   it { is_expected.to delegate_method(:klass).to(:container) }
  #   it { is_expected.to delegate_method(:methods_middlewares_callers).to(:container) }
  #   it { is_expected.to delegate_method(:ancestors).to(:klass) }
  # end

  example_group "instance methods" do
    ##
    # TODO: Specs.
    #
    # describe "#super_method_defined?" do
    #   # ...
    # end
    #
    describe "#ancestors_greater_than_methods_middlewares_callers" do
      context "when `service_class` does NOT have `methods_middlewares_callers`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core
            end
          end
        end

        it "returns empty array" do
          expect(caller.ancestors_greater_than_methods_middlewares_callers).to eq([])
        end
      end

      context "when `service_class` has `methods_middlewares_callers`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core

              middlewares(:result) {}
            end
          end
        end

        context "when `ancestors` do NOT contain `methods_middlewares_callers`" do
          let(:klass) { service_class.class }

          it "returns empty array" do
            expect(caller.ancestors_greater_than_methods_middlewares_callers).to eq([])
          end
        end

        context "when `ancestors` contains `methods_middlewares_callers`" do
          let(:klass) { service_class }

          specify do
            expect { caller.ancestors_greater_than_methods_middlewares_callers }
              .to delegate_to(ConvenientService::Utils::Array, :keep_after)
              .with_arguments(caller.ancestors, caller.methods_middlewares_callers)
              .and_return_its_value
          end
        end
      end
    end

    describe "#resolve_unbound_super_method" do
      context "when NO ancestors from `ancestors_greater_than_methods_middlewares_callers` have own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core
            end
          end
        end

        it "returns `nil`" do
          expect(caller.resolve_unbound_super_method(method_name)).to eq(nil)
        end
      end

      context "when one ancestor from `ancestors_greater_than_methods_middlewares_callers` has own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core

              concerns do |stack|
                stack.use concern
              end

              middlewares(:result) {}
              middlewares(:result, scope: :class) {}
            end
          end
        end

        context "when service class config is NOT committed" do
          it "returns `nil`" do
            expect(caller.resolve_unbound_super_method(method_name)).to eq(nil)
          end
        end

        context "when config is committed" do
          before do
            service_class.commit_config!
          end

          context "when container klass is service class" do
            let(:klass) { service_class }

            it "returns unbound own method from concern instance methods" do
              expect(caller.resolve_unbound_super_method(method_name)).to eq(concern::InstanceMethods.instance_method(method_name))
            end
          end

          context "when container klass is service class singleton class" do
            let(:klass) { service_class.singleton_class }

            it "returns unbound own method from concern class methods" do
              expect(caller.resolve_unbound_super_method(method_name)).to eq(concern::ClassMethods.instance_method(method_name))
            end
          end
        end
      end

      context "when multiple ancestors from `ancestors_greater_than_methods_middlewares_callers` have own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern, other_concern) do |concern, other_concern|
              include ConvenientService::Core

              concerns do |stack|
                stack.use concern

                stack.use other_concern
              end

              middlewares(:result) {}
              middlewares(:result, scope: :class) {}
            end
          end
        end

        context "when service class config is NOT committed" do
          it "returns `nil`" do
            expect(caller.resolve_unbound_super_method(method_name)).to eq(nil)
          end
        end

        context "when config is committed" do
          before do
            service_class.commit_config!
          end

          context "when container klass is service class" do
            let(:klass) { service_class }

            it "returns unbound own method from lowest of them (closest from inheritance chain) from concern instance methods" do
              expect(caller.resolve_unbound_super_method(method_name)).to eq(other_concern::InstanceMethods.instance_method(method_name))
            end
          end

          context "when container klass is service class singleton class" do
            let(:klass) { service_class.singleton_class }

            it "returns unbound own method from lowest of them (closest from inheritance chain) from concern class methods" do
              expect(caller.resolve_unbound_super_method(method_name)).to eq(other_concern::ClassMethods.instance_method(method_name))
            end
          end
        end
      end
    end

    ##
    # TODO: Specs.
    #
    # describe "#resolve_super_method" do
    #   # ...
    # end
    #
    describe "#to_kwargs" do
      let(:kwargs) { {container: container} }

      it "returns kwargs representation of caller" do
        expect(caller.to_kwargs).to eq(kwargs)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:caller) { caller_class.new(container: container) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns false" do
            expect(caller == other).to be_nil
          end
        end

        context "when `other` has different `container`" do
          let(:other) { described_class.new(container: double) }

          it "returns false" do
            expect(caller == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { caller_class.new(container: container) }

          it "returns true" do
            expect(caller == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
