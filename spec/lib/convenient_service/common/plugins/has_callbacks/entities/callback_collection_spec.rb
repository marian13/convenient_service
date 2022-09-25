# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Entities::CallbackCollection do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { described_class.new }

    it { is_expected.to have_attr_reader(:callbacks) }
  end

  ##
  # NOTE: Waits for `should-matchers' full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { described_class.new }
  #
  #   it { is_expected.to delegate_method(:each).to(:callbacks) }
  #   it { is_expected.to delegate_method(:include?).to(:callbacks) }
  #   it { is_expected.to delegate_method(:<<).to(:callbacks) }
  # end

  example_group "instance_methods" do
    subject(:callback_collection) { described_class.new }

    let(:callback) { ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback.new(types: types, block: proc { :foo }) }
    let(:types) { [:before, :result] }

    describe "#for" do
      context "when callback collection does NOT include callbacks exactly with types" do
        it "returns empty array" do
          expect(callback_collection.for(types)).to eq([])
        end
      end

      context "when callback collection includes callback exactly with types" do
        it "returns array with that callback" do
          callback_collection << callback

          expect(callback_collection.for(types)).to eq([callback])
        end

        context "when callback collection includes multiple callbacks exactly with types" do
          it "returns array with all those callbacks" do
            2.times { callback_collection << callback }

            expect(callback_collection.for(types)).to eq([callback] * 2)
          end
        end
      end
    end

    describe "#==" do
      context "when callback collections have different classes" do
        let(:other) { "string" }

        it "returns nil" do
          expect(callback_collection == other).to eq(nil)
        end
      end

      context "when callback collections have different `callbacks'" do
        let(:other) { described_class.new.tap { |collection| collection << callback } }

        it "returns false" do
          expect(callback_collection == other).to eq(false)
        end
      end

      context "when callback collections have same attributes" do
        let(:other) { described_class.new }

        it "returns true" do
          expect(callback_collection == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
