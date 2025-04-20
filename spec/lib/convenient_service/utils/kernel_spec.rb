# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Kernel, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".silence_warnings" do
    let(:namespace) { Module.new }
    let(:klass) { Class.new }

    let(:block) do
      proc do
        namespace.const_set(:Foo, klass)
        namespace.const_set(:Foo, klass)
      end
    end

    specify do
      expect { described_class.silence_warnings(&block) }
        .to delegate_to(described_class::SilenceWarnings, :call)
        .with_arguments(&block)
        .and_return_its_value
    end
  end
end
