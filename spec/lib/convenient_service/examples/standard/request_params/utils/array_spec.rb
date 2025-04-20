# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Utils::Array, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".wrap" do
      let(:object) { :foo }

      specify do
        expect { described_class.wrap(object) }
          .to delegate_to(described_class::Wrap, :call)
          .with_arguments(object)
          .and_return_its_value
      end
    end
  end
end
