# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:caller_instance) { caller_class.new(prefix: prefix) }
  let(:caller) { caller_instance }

  let(:prefix) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::INSTANCE_PREFIX }

  let(:container_instance) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }
  let(:container) { container_instance }

  let(:klass) { service_class }
  let(:service_class) { Class.new }

  let(:scope) { :instance }
  let(:method) { :result }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { caller }

    it { is_expected.to have_attr_reader(:prefix) }
  end

  example_group "instance methods" do
    describe "define_method_middlewares_caller!" do
      before do
        ##
        # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
        # NOTE: Used for `and_return_its_value`.
        # https://github.com/marian13/convenient_service/blob/c5b3adc4a0edc2d631dd1f44f914c28eeafefe1d/lib/convenient_service/rspec/matchers/custom/delegate_to.rb#L105
        #
        caller.define_method_middlewares_caller!(scope, method, container)
      end

      specify do
        expect { caller.define_method_middlewares_caller!(scope, method, container) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::DefineMethodMiddlewaresCaller, :call)
          .with_arguments(scope: scope, method: method, container: container, caller: caller)
          .and_return_its_value
      end
    end

    describe "#to_kwargs" do
      let(:kwargs) { {prefix: prefix} }

      it "returns kwargs representation of caller" do
        expect(caller.to_kwargs).to eq(kwargs)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:caller) { caller_class.new(prefix: prefix) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns false" do
            expect(caller == other).to be_nil
          end
        end

        context "when `other` has different `prefix`" do
          let(:other) { caller_class.new(prefix: double) }

          it "returns false" do
            expect(caller == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { caller_class.new(prefix: prefix) }

          it "returns true" do
            expect(caller == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
