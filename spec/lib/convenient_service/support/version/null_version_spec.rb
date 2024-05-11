# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Version::NullVersion, type: :standard do
  let(:version) { described_class.new }
  let(:other) { ConvenientService::Support::Version.new("0.2.1") }

  example_group "instance methods" do
    describe "#between?" do
      it "is undefined" do
        expect(version).not_to respond_to(:between?)
      end
    end

    describe "#clamp" do
      it "is undefined" do
        expect(version).not_to respond_to(:clamp)
      end
    end

    describe "#null_version?" do
      it "returns `true`" do
        expect(version.null_version?).to eq(true)
      end
    end

    describe "#gem_version" do
      it "returns `nil`" do
        expect(version.gem_version).to eq(nil)
      end
    end

    describe "#<=>" do
      it "returns `nil`" do
        expect(version <=> other).to eq(nil)
      end
    end

    describe "#<" do
      it "returns `nil`" do
        expect(version < other).to eq(nil)
      end
    end

    describe "#<=" do
      it "returns `nil`" do
        expect(version <= other).to eq(nil)
      end
    end

    describe "#==" do
      it "returns `nil`" do
        expect(version == other).to eq(nil)
      end
    end

    describe "#>=" do
      it "returns `nil`" do
        expect(version >= other).to eq(nil)
      end
    end

    describe "#>" do
      it "returns `nil`" do
        expect(version > other).to eq(nil)
      end
    end

    describe "#to_s" do
      it "returns empty string" do
        expect(version.to_s).to eq("")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
