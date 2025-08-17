# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::IncludeInOrder, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#include_module" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:mod) { Module.new }

      let(:keywords) { ["foo", "bar", "baz"] }

      specify do
        expect { instance.include_in_order(keywords) }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::IncludeInOrder, :new)
          .with_arguments(keywords)
      end
    end
  end
end
