# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "convenient_service"

# rubocop:disable RSpec/DescribeClass, RSpec/NestedGroups
RSpec.describe "convenient_service/version", type: :standard do
  example_group "constants" do
    describe "::VERSION" do
      it "returns version" do
        expect(ConvenientService::VERSION).to be_instance_of(String)
      end

      it "follows Semantic Versioning" do
        expect(ConvenientService::VERSION).to match(/\d+\.\d+\.\d+/)
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass, RSpec/NestedGroups
