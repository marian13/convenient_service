# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::ObjectIsNotEnumerable).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ObjectIsNotEnumerator).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::AlreadyUsedTerminalChaining).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::InvalidEvaluateByValue).to be_descendant_of(ConvenientService::Exception) }
end
