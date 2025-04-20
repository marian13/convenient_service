# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Kernel::SilenceWarnings, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(&block) }

      let(:namespace) { Module.new }
      let(:klass) { Class.new }

      let(:block) do
        proc do
          namespace.const_set(:Foo, klass)
          namespace.const_set(:Foo, klass)
        end
      end

      it "silences warnings" do
        expect { command_result }.not_to output.to_stderr
      end

      it "returns block value" do
        expect(command_result).to eq(klass)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
