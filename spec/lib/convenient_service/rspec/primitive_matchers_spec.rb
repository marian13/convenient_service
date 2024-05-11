# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers, type: :standard do
  example_group "modules" do
    include described_class::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { klass }

      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::BeDescendantOf) }
      it { is_expected.to include_module(described_class::BeDirectDescendantOf) }
      it { is_expected.to include_module(described_class::CacheItsValue) }
      it { is_expected.to include_module(described_class::DelegateTo) }
      it { is_expected.to include_module(described_class::ExtendModule) }
      it { is_expected.to include_module(described_class::HaveAbstractMethod) }
      it { is_expected.to include_module(described_class::HaveAliasMethod) }
      it { is_expected.to include_module(described_class::HaveAttrAccessor) }
      it { is_expected.to include_module(described_class::HaveAttrReader) }
      it { is_expected.to include_module(described_class::HaveAttrWriter) }
      it { is_expected.to include_module(described_class::IncludeModule) }
      it { is_expected.to include_module(described_class::PrependModule) }
      it { is_expected.to include_module(described_class::SingletonPrependModule) }
    end
  end
end
