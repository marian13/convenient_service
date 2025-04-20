# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveHelpers::IgnoringException, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#ignoring_exception" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:exception) { ArgumentError }
      let(:block) { proc { raise exception } }

      specify do
        expect { instance.ignoring_exception(exception, &block) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveHelpers::Classes::IgnoringException, :new)
          .with_arguments(exception, &block)
      end
    end
  end
end
