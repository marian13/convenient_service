# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Object::InstanceVariableDelete, type: :standard do
  describe ".call" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:ivar_value) { :bar }

    context "when ivar is NOT defined" do
      let(:result) { described_class.call(object, ivar_name) }

      it "returns `nil`" do
        expect(result).to be_nil
      end
    end

    context "when ivar is defined" do
      let(:object) do
        Object.new.tap do |object|
          object.instance_variable_set(ivar_name, ivar_value)
        end
      end

      let(:result) { described_class.call(object, ivar_name) }

      it "removes that ivar value" do
        result

        expect(object.instance_variable_defined?(ivar_name)).to be(false)
      end

      it "returns that ivar value" do
        expect(result).to eq(ivar_value)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
