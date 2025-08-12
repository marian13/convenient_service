# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService, type: :standard do
  example_group "constants" do
    describe "::VERSION" do
      it "returns version" do
        expect(described_class::VERSION).to be_instance_of(String)
      end

      it "follows Semantic Versioning" do
        expect(described_class::VERSION).to match(/\d+\.\d+\.\d+/)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
