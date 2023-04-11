# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Base do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:cache) { described_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "class methods" do
    describe ".keygen" do
      let(:args) { :foo }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { described_class.keygen(*args, **kwargs, &block) }
          .to delegate_to(ConvenientService::Support::Cache::Entities::Key, :new)
          .with_arguments(*args, **kwargs, &block)
          .and_return_its_value
      end
    end
  end

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { cache }

      it { is_expected.to have_abstract_method(:empty?) }
      it { is_expected.to have_abstract_method(:exist?) }
      it { is_expected.to have_abstract_method(:read) }
      it { is_expected.to have_abstract_method(:write) }
      it { is_expected.to have_abstract_method(:fetch) }
      it { is_expected.to have_abstract_method(:delete) }
      it { is_expected.to have_abstract_method(:clear) }
    end

    describe "#keygen" do
      let(:args) { :foo }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { cache.keygen(*args, **kwargs, &block) }
          .to delegate_to(cache.class, :keygen)
          .with_arguments(*args, **kwargs, &block)
          .and_return_its_value
      end
    end

    ##
    # NOTE: Tested by descendants.
    #
    # describe "#[]" do
    # end

    ##
    # NOTE: Tested by descendants.
    #
    # describe "#[]=" do
    # end
  end
end
# rubocop:enable RSpec/NestedGroups
