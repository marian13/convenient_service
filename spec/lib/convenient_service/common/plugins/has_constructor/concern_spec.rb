# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasConstructor::Concern do
  let(:klass) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { klass }

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#create" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            attr_reader :args, :kwargs, :block

            def initialize(*args, **kwargs, &block)
              @args = args
              @kwargs = kwargs
              @block = block
            end

            ##
            # Needed for `delegate_to`.
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              args == other.args && kwargs == other.kwargs && block == other.block
            end
          end
        end
      end

      let(:args) { :foo }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { klass.create(*args, **kwargs, &block) }
          .to delegate_to(klass, :new)
          .with_arguments(*args, **kwargs, &block)
          .and_return_its_value
      end
    end
  end
end
