# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Concern::InstanceMethods do
  let(:method_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:method_instance) { method_class.new(**method_kwargs) }

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(method_other, method_return_value) do |method_other, method_return_value|
        define_method(method_other) { method_return_value }
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:method_kwargs) { {key: key, name: name, caller: caller, direction: direction, organizer: organizer} }
  let(:method_other) { :foo }
  let(:method_options) { {direction: :input} }
  let(:method_return_value) { "method return value" }

  let(:key) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: method_other, options: method_options).name }
  let(:name) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: method_other, options: method_options).name }
  let(:caller) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: method_other, options: method_options).caller }
  let(:direction) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: method_other, options: method_options).direction }

  let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
  let(:organizer) { service_instance }
  let(:method) { method_instance }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
    include ConvenientService::RSpec::Matchers::DelegateTo

    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { method_instance }

      it { is_expected.to have_attr_reader(:key) }
      it { is_expected.to have_attr_reader(:name) }
      it { is_expected.to have_attr_reader(:caller) }
      it { is_expected.to have_attr_reader(:direction) }
      it { is_expected.to have_attr_reader(:organizer) }
    end

    ##
    # NOTE: Waits for `should-matchers` full support.
    #
    # example_group "delegators" do
    #   include Shoulda::Matchers::Independent
    #
    #   subject { method_instance }
    #
    #   it { is_expected.to delegate_method(:to_s).to(:name) }
    # end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(method == other).to be_nil
          end
        end

        context "when `other` has different `key`" do
          let(:other) { method_class.new(**method_kwargs.merge(key: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: :bar, options: method_options).key)) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `name`" do
          let(:other) { method_class.new(**method_kwargs.merge(name: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: :bar, options: method_options).name)) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `caller`" do
          let(:other) { method_class.new(**method_kwargs.merge(caller: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: :bar, options: method_options).caller)) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `direction`" do
          let(:other) { method_class.new(**method_kwargs.merge(direction: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod.call(other: method_other, options: {direction: :output}).caller)) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has different `organizer`" do
          let(:other) { method_class.new(**method_kwargs.merge(organizer: service_class.new)) }

          it "returns `false`" do
            expect(method == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { method_class.new(**method_kwargs) }

          it "returns `true`" do
            expect(method == other).to eq(true)
          end
        end
      end
    end

    describe "#has_orgnizer?" do
      context "when `method` does NOT have `organizer`" do
        let(:method_instance) { method_class.new(**ConvenientService::Utils::Hash.except(method_kwargs, [:organizer])) }

        it "returns `false`" do
          expect(method.has_organizer?).to eq(false)
        end
      end

      context "when `method` has `organizer`" do
        let(:method_instance) { method_class.new(**method_kwargs.merge(organizer: organizer)) }

        it "returns `true`" do
          expect(method.has_organizer?).to eq(true)
        end
      end
    end

    describe "#reassignment?" do
      let(:name) { :foo }

      specify do
        expect { method.reassignment?(name) }
          .to delegate_to(caller, :reassignment?)
          .with_arguments(name)
          .and_return_its_value
      end
    end

    describe "#validate_as_input_for_container!" do
      let(:method_options) { {direction: :input} }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_other, method_return_value) do |method_other, method_return_value|
            define_method(method_other) { method_return_value }
          end
        end
      end

      it "returns `true`" do
        expect(method.validate_as_input_for_container!(container)).to eq(true)
      end

      specify do
        expect { method.validate_as_input_for_container!(container) }
          .to delegate_to(direction, :validate_as_input_for_container!)
          .with_arguments(container, method: method)
          .and_return_its_value
      end

      specify do
        expect { method.validate_as_input_for_container!(container) }
          .to delegate_to(caller, :validate_as_input_for_container!)
          .with_arguments(container, method: method)
          .and_return_its_value
      end
    end

    describe "#validate_as_output_for_container!" do
      let(:method_options) { {direction: :output} }
      let(:service_class) { Class.new }

      it "returns `true`" do
        expect(method.validate_as_output_for_container!(container)).to eq(true)
      end

      specify do
        expect { method.validate_as_output_for_container!(container) }
          .to delegate_to(direction, :validate_as_output_for_container!)
          .with_arguments(container, method: method)
          .and_return_its_value
      end

      specify do
        expect { method.validate_as_output_for_container!(container) }
          .to delegate_to(caller, :validate_as_output_for_container!)
          .with_arguments(container, method: method)
          .and_return_its_value
      end
    end

    describe "#define_output_in_container!" do
      let(:method_options) { {direction: :output} }
      let(:service_class) { Class.new }
      let(:index) { 0 }

      it "returns `true`" do
        expect(method.define_output_in_container!(container, index: index)).to eq(true)
      end

      specify do
        expect { method.define_output_in_container!(container, index: index) }
          .to delegate_to(direction, :define_output_in_container!)
          .with_arguments(container, index: index, method: method)
          .and_return_its_value
      end

      specify do
        expect { method.define_output_in_container!(container, index: index) }
          .to delegate_to(caller, :define_output_in_container!)
          .with_arguments(container, index: index, method: method)
          .and_return_its_value
      end
    end

    describe "#organizer" do
      context "when `method` does NOT have `organizer`" do
        let(:method_instance) { method_class.new(**ConvenientService::Utils::Hash.except(method_kwargs, [:organizer])) }

        context "when `raise_when_missing` is NOT passed" do
          let(:message) do
            <<~TEXT
              Organizer for method `:#{method.name}` is NOT assigned yet.

              Did you forget to set it?
            TEXT
          end

          it "defaults to `true`" do
            expect { method.organizer }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
              .with_message(message)
          end
        end

        context "when `raise_when_missing` is `false`" do
          it "returns `nil`" do
            expect(method.organizer(raise_when_missing: false)).to be_nil
          end
        end

        context "when `raise_when_missing` is `true`" do
          let(:method_instance) { method_class.new(**ConvenientService::Utils::Hash.except(method_kwargs, [:organizer])) }

          let(:message) do
            <<~TEXT
              Organizer for method `:#{method.name}` is NOT assigned yet.

              Did you forget to set it?
            TEXT
          end

          it "returns `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
            expect { method.organizer(raise_when_missing: true) }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
              .with_message(message)
          end
        end
      end

      context "when `method` has `organizer`" do
        let(:method_instance) { method_class.new(**method_kwargs.merge(organizer: organizer)) }

        it "returns that organizer" do
          expect(method.organizer).to eq(organizer)
        end

        specify do
          expect { method.organizer }.to cache_its_value
        end
      end
    end

    describe "#value" do
      context "when `method` does NOT have `organizer`" do
        let(:method_instance) { method_class.new(**ConvenientService::Utils::Hash.except(method_kwargs, [:organizer])) }

        let(:exception_message) do
          <<~TEXT
            Organizer for method `:#{method.name}` is NOT assigned yet.

            Did you forget to set it?
          TEXT
        end

        it "returns `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
          expect { method.value }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
            .with_message(exception_message)
        end
      end

      context "when `method` has `organizer`" do
        let(:method_instance) { method_class.new(**method_kwargs.merge(organizer: organizer)) }

        it "returns `method` return value" do
          expect(method.value).to eq(method_return_value)
        end

        it "caches `method` return value" do
          expect(method.value.object_id).to eq(method.value.object_id)
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {key: key, name: name, caller: caller, direction: direction, organizer: organizer} }

      describe "#to_kwargs" do
        specify do
          allow(method).to receive(:to_arguments).and_return(arguments)

          expect { method.to_kwargs }
            .to delegate_to(method.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of method" do
          expect(method.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
