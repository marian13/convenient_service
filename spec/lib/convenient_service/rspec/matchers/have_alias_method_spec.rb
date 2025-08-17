# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::HaveAliasMethod, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#have_alias_method" do
      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      let(:instance) { klass.new }

      let(:method) { :foo }
      let(:alias_method) { :bar }

      specify do
        expect { instance.have_alias_method(method, alias_method) }
          .to delegate_to(ConvenientService::RSpec::Matchers::Classes::HaveAliasMethod, :new)
          .with_arguments(method, alias_method)
      end
    end
  end
end
