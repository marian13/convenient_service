# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Delegate do
  include ConvenientService::RSpec::Matchers::IncludeModule
  include ConvenientService::RSpec::Matchers::ExtendModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "when included" do
    subject do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    it { is_expected.to extend_module(::Forwardable) }
    it { is_expected.to extend_module(described_class::ClassMethodsForForwardable) }
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
