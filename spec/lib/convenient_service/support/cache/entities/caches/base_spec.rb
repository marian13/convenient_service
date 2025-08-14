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
      subject { cache }

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      it { is_expected.to respond_to(:store) }
      it { is_expected.to respond_to(:default) }
      it { is_expected.to respond_to(:parent) }
      it { is_expected.to respond_to(:key) }
    end

    example_group "abstract methods" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      specify { expect { cache.empty? }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.exist? }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.read }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.write }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.fetch }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.delete }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.clear }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.scope }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.scope! }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
      specify { expect { cache.default = 42 }.to raise_error(ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden) }
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
