# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Config::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::OptionCanNotBeNormalized).to be_descendant_of(ConvenientService::Exception) }
end
# rubocop:enable RSpec/NestedGroups
