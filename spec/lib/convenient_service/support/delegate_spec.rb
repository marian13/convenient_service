# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Delegate, type: :standard do
  example_group "modules" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class.ancestors.drop_while { |ancestor| ancestor != described_class }.include?(ConvenientService::Support::Concern)).to eq(true) }
  end

  example_group "when included" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(klass.singleton_class.ancestors.drop_while { |ancestor| ancestor != klass.singleton_class }.include?(Forwardable)).to eq(true) }
    specify { expect(klass.singleton_class.ancestors.drop_while { |ancestor| ancestor != klass.singleton_class }.include?(described_class::ClassMethodsForForwardable)).to eq(true) }
  end

  example_group "class methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    describe ".delegate" do
      it "delegates to `Forwardable#def_delegators`" do
        allow(klass).to receive(:def_delegators).with(:itself, :to_s).and_call_original

        ##
        # TODO: Contribute. `Forwardable` can not accept `:class`.
        #
        klass.delegate :to_s, to: :itself

        expect(klass).to have_received(:def_delegators)
      end

      context "when `to` is `class`" do
        it "delegates to `Forwardable#def_delegators` with `self.class`" do
          allow(klass).to receive(:def_delegators).with(:"self.class", :to_s).and_call_original

          ##
          # TODO: Contribute. `Forwardable` can not accept `:class`.
          #
          klass.delegate :to_s, to: :class

          expect(klass).to have_received(:def_delegators)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
