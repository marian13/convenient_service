# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::IncludeModule, type: :standard do
  describe ".call" do
    let(:other_mod) { Module.new }

    let(:result) { described_class.call(mod, other_mod) }

    context "when `mod` does NOT include `other_mod`" do
      let(:mod) { Class.new }

      it "returns `false`" do
        expect(result).to be(false)
      end
    end

    context "when `mod` includes `other_mod`" do
      let(:mod) do
        Class.new.tap do |klass|
          klass.instance_exec(other_mod) do |other_mod|
            include other_mod
          end
        end
      end

      it "returns `true`" do
        expect(result).to be(true)
      end
    end

    context "when `mod` prepends `other_mod`" do
      let(:mod) do
        Class.new.tap do |klass|
          klass.instance_exec(other_mod) do |other_mod|
            prepend other_mod
          end
        end
      end

      it "returns `false`" do
        expect(result).to be(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
