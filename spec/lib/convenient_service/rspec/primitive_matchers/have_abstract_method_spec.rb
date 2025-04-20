# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    describe "#have_abstract_method" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:method) { :foo }

      specify do
        expect { instance.have_abstract_method(method) }
          .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::HaveAbstractMethod, :new)
          .with_arguments(method)
      end
    end
  end
end
