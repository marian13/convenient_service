# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Concern::ClassMethods, type: :standard do
  example_group "instance methods" do
    describe "#[]" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { service_class[*args, **kwargs, &block] }
          .to delegate_to(service_class, :result)
          .with_arguments(*args, **kwargs, &block)
          .and_return_its_value
      end
    end
  end
end
