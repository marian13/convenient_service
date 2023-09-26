# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers do
  example_group "modules" do
    include ConvenientService::RSpec::PrimitiveMatchers::IncludeModule

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

      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::BeDirectDescendantOf) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::DelegateTo) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::ExtendModule) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::HaveAliasMethod) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::HaveAttrAccessor) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::HaveAttrWriter) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::IncludeModule) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::PrependModule) }
      it { is_expected.to include_module(ConvenientService::RSpec::PrimitiveMatchers::SingletonPrependModule) }
    end
  end
end
