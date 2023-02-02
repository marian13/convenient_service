# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Version do
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:version) { described_class.new(value) }
  let(:value) { "1.0.0" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(Comparable) }
  end

  example_group "class methods" do
    describe ".null_version" do
      it "returns null version" do
        expect(described_class.null_version).to be_instance_of(described_class::NullVersion)
      end
    end
  end

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
      it "returns `false`" do
        expect(version.null_version?).to eq(false)
      end
    end

    describe "#gem_version" do
      let(:value) { "0.2.1" }

      it "returns `Gem::Version`" do
        expect(version.gem_version).to eq(Gem::Version.new(value.to_s))
      end

      context "when value is castable" do
        let(:value) { "abc" }

        it "returns `nil`" do
          expect(version.gem_version).to eq(nil)
        end
      end

      context "when casts" do
        let(:value) { Object.new }

        it "delegates to `Gem::Version#correct?` + casts value to string" do
          allow(Gem::Version).to receive(:correct?).with(value.to_s).and_call_original

          version.gem_version

          expect(Gem::Version).to have_received(:correct?).with(value.to_s)
        end
      end
    end

    describe "#<=>" do
      context "when compares" do
        let(:other) { described_class.new("2.0.0") }

        ##
        # `Gem::Version` knows how to compare respecting the semantic versioning.
        #
        it "delegates to `Gem::Version#<=>`" do
          allow(version.gem_version).to receive(:<=>).with(other.gem_version).and_call_original

          ##
          # NOTE: Disables `Lint/Void` since `version <=> other` is used to trigger method under test.
          # https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Lint/Void
          #
          # rubocop:disable Lint/Void
          version <=> other
          # rubocop:enable Lint/Void

          expect(version.gem_version).to have_received(:<=>).with(other.gem_version)
        end

        ##
        # NOTE:
        #   "3.10.1" > "3.9.4"
        #   # false by String#>.
        #   # https://ruby-doc.org/core-2.7.0/String.html#method-i-3C-3D-3E
        #
        #   "3.10.1" > "3.9.4"
        #   # true by Semantic Versioning.
        #   # https://semver.org
        #
        it "respects Semantic Versioning" do
          expect(described_class.new("3.10.1") > described_class.new("3.9.4")).to eq(true)
        end
      end

      context "when other is NOT castable" do
        let(:other) { "string" }

        it "returns `nil`" do
          expect(version <=> other).to eq(nil)
        end
      end

      context "when other is lower version" do
        let(:other) { described_class.new("0.2.1") }

        it "returns `1`" do
          expect(version <=> other).to eq(1)
        end
      end

      context "when other is equal version" do
        let(:other) { described_class.new("1.0.0") }

        it "returns `0`" do
          expect(version <=> other).to eq(0)
        end
      end

      context "when other is greater version" do
        let(:other) { described_class.new("2.0.0") }

        it "returns `-1`" do
          expect(version <=> other).to eq(-1)
        end
      end
    end

    describe "#to_s" do
      it "returns string represantation of string" do
        expect(version.to_s).to eq(value)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
