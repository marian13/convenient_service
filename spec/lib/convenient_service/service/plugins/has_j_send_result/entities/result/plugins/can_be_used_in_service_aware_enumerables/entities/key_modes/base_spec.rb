# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes::Base, type: :standard do
  example_group "instance methods" do
    let(:key_mode) { described_class.new }

    describe "#none?" do
      it "returns `false`" do
        expect(key_mode.none?).to be(false)
      end
    end

    describe "#one?" do
      it "returns `false`" do
        expect(key_mode.one?).to be(false)
      end
    end

    describe "#many?" do
      it "returns `false`" do
        expect(key_mode.many?).to be(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
