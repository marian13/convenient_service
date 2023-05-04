# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::BeDescendantOf) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::BeDirectDescendantOf) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::CacheItsValue) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::CallChainNext) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::DelegateTo) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::Export) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::ExtendModule) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::HaveAbstractMethod) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::HaveAliasMethod) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::HaveAttrAccessor) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::HaveAttrReader) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::HaveAttrWriter) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::Import) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::IncludeModule) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::PrependModule) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::Results) }
      it { is_expected.to include_module(ConvenientService::RSpec::Matchers::SingletonPrependModule) }
    end
  end
end
