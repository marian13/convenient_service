# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::HaveAttrAccessor, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#have_attr_accessor" do
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
        expect { instance.have_attr_accessor(method) }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::HaveAttrAccessor, :new)
          .with_arguments(method)
      end
    end
  end
end
