# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::DelegateTo, type: :standard do
  include described_class

  example_group "instance methods" do
    describe "#delegate_to" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:object) { OpenStruct.new(foo: :bar) }
      let(:method) { :foo }

      specify do
        expect { instance.delegate_to(object, method) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo, :new)
          .with_arguments(object, method)
      end
    end
  end
end
