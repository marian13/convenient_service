# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::FallbackResultIsNotOverridden).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::MethodStepCanNotHaveFallback).to be_descendant_of(ConvenientService::Exception) }
end
