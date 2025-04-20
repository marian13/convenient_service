# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Base, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:cache) { described_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `store` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.store).to be_nil
        end
      end

      context "when `default` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.default).to be_nil
        end
      end

      context "when `parent` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.parent).to be_nil
        end
      end

      context "when `key` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.key).to be_nil
        end
      end
    end

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
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { cache }

      it { is_expected.to have_attr_reader(:store) }
      it { is_expected.to have_attr_reader(:default) }
      it { is_expected.to have_attr_reader(:parent) }
      it { is_expected.to have_attr_reader(:key) }
    end

    example_group "abstract methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod

      subject { cache }

      it { is_expected.to have_abstract_method(:empty?) }
      it { is_expected.to have_abstract_method(:exist?) }
      it { is_expected.to have_abstract_method(:read) }
      it { is_expected.to have_abstract_method(:write) }
      it { is_expected.to have_abstract_method(:fetch) }
      it { is_expected.to have_abstract_method(:delete) }
      it { is_expected.to have_abstract_method(:clear) }
      it { is_expected.to have_abstract_method(:scope) }
      it { is_expected.to have_abstract_method(:scope!) }
      it { is_expected.to have_abstract_method(:default=) }
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

    ##
    # NOTE: Tested by descendants.
    #
    # describe "#get" do
    # end
    ##

    ##
    # NOTE: Tested by descendants.
    #
    # describe "#[]=" do
    # end
    ##

    ##
    # NOTE: Tested by descendants.
    #
    # describe "#set" do
    # end
    ##

    ##
    # NOTE: Tested by descendants.
    #
    # describe "#default=" do
    # end
    ##

    ##
    # NOTE: Tested by descendants.
    #
    # example_group "comparison" do
    #   describe "#==" do
    #   end
    # end
    ##
  end
end
# rubocop:enable RSpec/NestedGroups
