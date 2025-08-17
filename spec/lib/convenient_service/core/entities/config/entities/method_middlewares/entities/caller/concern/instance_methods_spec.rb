# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Concern::InstanceMethods, type: :standard do
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

  let(:prefix) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Constants::INSTANCE_PREFIX }

  let(:container_instance) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }
  let(:container) { container_instance }

  let(:klass) { service_class }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

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
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#define_method_callers!" do
      before do
        ##
        # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
        # NOTE: Used for `and_return_its_value`.
        # https://github.com/marian13/convenient_service/blob/c5b3adc4a0edc2d631dd1f44f914c28eeafefe1d/lib/convenient_service/rspec/matchers/custom/delegate_to.rb#L105
        #
        caller.define_method_callers!(scope, method, container)
      end

      specify do
        expect { caller.define_method_callers!(scope, method, container) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::DefineMethodCallers, :call)
          .with_arguments(scope: scope, method: method, container: container, caller: caller)
          .and_return_its_value
      end
    end

    describe "#undefine_method_callers!" do
      before do
        ##
        # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
        # NOTE: Used for `and_return_its_value`.
        # https://github.com/marian13/convenient_service/blob/c5b3adc4a0edc2d631dd1f44f914c28eeafefe1d/lib/convenient_service/rspec/matchers/custom/delegate_to.rb#L105
        #
        caller.undefine_method_callers!(scope, method, container)
      end

      specify do
        expect { caller.undefine_method_callers!(scope, method, container) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::UndefineMethodCallers, :call)
          .with_arguments(scope: scope, method: method, container: container)
          .and_return_its_value
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {prefix: prefix} }

      describe "#to_kwargs" do
        specify do
          allow(caller).to receive(:to_arguments).and_return(arguments)

          expect { caller.to_kwargs }
            .to delegate_to(caller.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of caller" do
          expect(caller.to_arguments).to eq(arguments)
        end
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
          let(:other) { caller_class.new(prefix: ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Constants::INSTANCE_PREFIX) }

          it "returns true" do
            expect(caller == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
