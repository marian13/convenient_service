# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveHelpers::InThreads, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#in_threads" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:n) { 2 }
      let(:array) { [] }
      let(:block) { proc { |array| array << :foo } }

      specify do
        expect { instance.in_threads(n, array, &block) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveHelpers::Classes::InThreads, :new)
          .with_arguments(n, array, &block)
      end
    end
  end
end
