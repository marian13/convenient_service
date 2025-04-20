# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::DependencyContainer::Container, type: :standard do
  subject { described_class }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    it { is_expected.to include_module(ConvenientService::DependencyContainer::Export) }
  end

  example_group "exported methods" do
    include ConvenientService::RSpec::Matchers::Export

    it { is_expected.to export(:"constants.DEFAULT_SCOPE") }

    it { is_expected.to export(:"commands.AssertValidContainer") }

    it { is_expected.to export(:"commands.AssertValidScope") }
  end
end
