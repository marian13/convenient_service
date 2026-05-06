# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveInlineServices, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".proxy" do
      let(:block) { proc { :foo } }

      specify do
        expect { described_class.proxy(&block) }
          .to delegate_to(described_class::Entities::Proxy, :new)
          .with_arguments(&block)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
