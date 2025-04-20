# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveParentResult::Constants, type: :standard do
  example_group "constants" do
    describe "::SCOPES" do
      it "returns `1_000`" do
        expect(described_class::PARENTS_LIMIT).to eq(1_000)
      end
    end
  end
end
