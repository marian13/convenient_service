# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::DependencyContainer::Exceptions, type: :standard do
  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class::InvalidScope < ConvenientService::Exception).to be(true) }
    specify { expect(described_class::NotExportableModule < ConvenientService::Exception).to be(true) }
    specify { expect(described_class::NotExportedMethod < ConvenientService::Exception).to be(true) }
    specify { expect(described_class::NotModule < ConvenientService::Exception).to be(true) }
  end
end
