# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { caller_class.new(entity: entity) }
  let(:caller_class) { described_class }

  let(:entity) { double }
  let(:method) { :result }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { caller }

    it { is_expected.to have_attr_reader(:entity) }
  end

  example_group "abstract methods" do
    include ConvenientService::RSpec::Matchers::HaveAbstractMethod

    subject { caller }

    it { is_expected.to have_abstract_method(:commit_config!) }
    it { is_expected.to have_abstract_method(:ancestors) }
    it { is_expected.to have_abstract_method(:methods_middlewares_callers) }
  end

  # example_group "instance methods" do
  #   describe "ancestors_before_methods_middlewares_callers" do
  #     ##
  #     # TODO:
  #     #
  #   end
  #
  #   describe "#resolve_super_method" do
  #     ##
  #     # NOTE: `#resolve_super_method` is tested in `ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base` descendants.
  #     #
  #  end
  # end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
