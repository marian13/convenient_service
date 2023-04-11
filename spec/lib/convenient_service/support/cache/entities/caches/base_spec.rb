# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Base do
  let(:cache) { described_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { cache }

      it { is_expected.to have_abstract_method(:empty?) }
      it { is_expected.to have_abstract_method(:exist?) }
      it { is_expected.to have_abstract_method(:read) }
      it { is_expected.to have_abstract_method(:write) }
      it { is_expected.to have_abstract_method(:delete) }
      it { is_expected.to have_abstract_method(:clear) }
    end

    ##
    # TODO:
    #
  end
end
# rubocop:enable RSpec/NestedGroups
