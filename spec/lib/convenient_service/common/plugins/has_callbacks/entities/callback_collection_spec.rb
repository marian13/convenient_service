# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Entities::CallbackCollection do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(Enumerable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { described_class.new }

    it { is_expected.to have_attr_reader(:callbacks) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
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

  example_group "instance methods" do
    subject(:callback_collection) { described_class.new }

    let(:callback) { ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback.new(**kwargs) }

    let(:kwargs) { {types: types, block: block} }
    let(:types) { [:before, :result] }
    let(:block) { proc { :foo } }

    describe "#callbacks" do
      context "when `callback_collection` has NO callbacks" do
        it "returns empty array" do
          expect(callback_collection.callbacks).to eq([])
        end
      end

      context "when `callback_collection` has callbacks" do
        before do
          callback_collection.create(**kwargs)
        end

        it "returns array with those callbacks" do
          expect(callback_collection.callbacks).to eq([callback])
        end
      end
    end

    describe "#callback_class" do
      it "returns `ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback`" do
        expect(callback_collection.callback_class).to eq(ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback)
      end
    end

    describe "#for" do
      context "when callback collection does NOT include callbacks exactly with types" do
        it "returns empty array" do
          expect(callback_collection.for(types)).to eq([])
        end
      end

      context "when callback collection includes callback exactly with types" do
        it "returns array with that callback" do
          callback_collection.create(**kwargs)

          expect(callback_collection.for(types)).to eq([callback])
        end

        context "when callback collection includes multiple callbacks exactly with types" do
          it "returns array with all those callbacks" do
            2.times { callback_collection.create(**kwargs) }

            expect(callback_collection.for(types)).to eq([callback] * 2)
          end
        end
      end
    end

    describe "#create" do
      it "adds `callback` to `callbacks`" do
        callback_collection.create(types: types, block: block)

        expect(callback_collection.callbacks).to include(callback)
      end

      it "returns `callback`" do
        expect(callback_collection.create(types: types, block: block)).to eq(callback)
      end
    end

    describe "#==" do
      context "when callback collections have different classes" do
        let(:other) { "string" }

        it "returns nil" do
          expect(callback_collection == other).to eq(nil)
        end
      end

      context "when callback collections have different `callbacks`" do
        let(:other) { described_class.new.tap { |collection| collection.create(**kwargs) } }

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
