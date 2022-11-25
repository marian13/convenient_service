# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern do
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

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#create_without_initialize" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            ##
            # Needed for `delegate_to`.
            #
            def ==(other)
              other.instance_of?(self.class)
            end
          end
        end
      end

      specify do
        expect { klass.create_without_initialize }
          .to delegate_to(klass, :allocate)
          .and_return_its_value
      end
    end
  end
end
