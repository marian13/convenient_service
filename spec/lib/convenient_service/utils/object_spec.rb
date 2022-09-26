# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Object do
  describe ".find_own_const" do
    let(:result) { described_class.find_own_const(object, const_name) }

    let(:object) { Class.new }

    context "when const is NOT defined directly inside object namespace" do
      context "when const is NOT defined at all" do
        let(:const_name) { :NotExistingConst }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end

      context "when const is defined outside object namespace" do
        ##
        # NOTE: `File` is defined in `Object` class from Ruby Core.
        #
        let(:const_name) { :File }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end
    end

    context "when const is defined directly inside object namespace" do
      let(:object) do
        Class.new.tap do |klass|
          klass.const_set(:File, Class.new)
        end
      end

      let(:const_name) { :File }

      it "returns that const" do
        expect(result).to eq(object::File)
      end
    end
  end

  describe ".resolve_type" do
    let(:result) { described_class.resolve_type(object) }

    context "when `object` is module" do
      let(:object) { Kernel }

      it "returns `module` string" do
        expect(result).to eq("module")
      end
    end

    context "when `object` is class" do
      let(:object) { Array }

      it "returns `class` string" do
        expect(result).to eq("class")
      end
    end

    context "when `object` is neither module nor class" do
      let(:object) { "foo" }

      it "returns `instance` string" do
        expect(result).to eq("instance")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
