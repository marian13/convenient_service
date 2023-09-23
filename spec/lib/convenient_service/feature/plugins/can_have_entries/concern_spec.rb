# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveEntries::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:feature_class) do
    Class.new do
      include ConvenientService::Feature::Configs::Standard
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { feature_class }

      let(:feature_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".entry" do
      let(:name) { :foo }
      let(:body) { proc { :foo } }

      specify do
        expect { feature_class.entry(name, &body) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry, :call)
          .with_arguments(feature_class: feature_class, name: name, body: body)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
