# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::Factorial::Utils::Timeout, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".with_timeout" do
      let(:seconds) { 5 }
      let(:block) { proc { :foo } }

      specify do
        expect { described_class.with_timeout(seconds, &block) }
          .to delegate_to(described_class::WithTimeout, :call)
          .with_arguments(seconds, &block)
          .and_return_its_value
      end
    end
  end
end
