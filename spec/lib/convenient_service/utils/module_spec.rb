# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module do
  describe ".find_own_const" do
    let(:result) { described_class.find_own_const(mod, const_name) }

    let(:mod) { Class.new }

    context "when const is NOT defined directly inside module namespace" do
      context "when const is NOT defined at all" do
        let(:const_name) { :NotExistingConst }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end

      context "when const is defined outside module namespace" do
        ##
        # NOTE: `File` is defined in `Object` class from Ruby Core.
        #
        let(:const_name) { :File }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end
    end

    context "when const is defined directly inside module namespace" do
      let(:mod) do
        Class.new.tap do |klass|
          klass.const_set(:File, Class.new)
        end
      end

      let(:const_name) { :File }

      it "returns that const" do
        expect(result).to eq(mod::File)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
