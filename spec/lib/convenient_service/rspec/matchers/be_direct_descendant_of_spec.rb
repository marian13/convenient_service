# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::BeDirectDescendantOf, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#be_direct_descendant_of" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:parent) { String }

      specify do
        expect { instance.be_direct_descendant_of(parent) }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::BeDirectDescendantOf, :new)
          .with_arguments(parent)
      end
    end
  end
end
