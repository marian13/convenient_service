# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::GetOwnConst, type: :standard do
  describe ".call" do
    let(:result) { described_class.call(mod, const_name) }

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
