# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Concern, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    ##
    # TODO: Uncomment.
    #
    # include ConvenientService::RSpec::PrimitiveMatchers::HaveAliasMethod

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { entity_class }

      let(:entity_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }

      ##
      # TODO: Uncomment.
      #
      # specify { expect(entity_class.singleton_class).to have_alias_method(:new_without_commit_config, :new) }
    end
  end
end
