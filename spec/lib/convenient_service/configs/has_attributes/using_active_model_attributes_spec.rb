# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        let(:concerns) do
          [
            ConvenientService::Common::Plugins::HasAttributes::UsingActiveModelAttributes::Concern
          ]
        end

        it "sets service concerns" do
          expect(service_class.concerns.to_a.map(&:first).map(&:concern)).to eq(concerns)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
