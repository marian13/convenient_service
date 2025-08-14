# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Kernel, type: :standard do
  describe ".silence_warnings" do
    let(:namespace) { Module.new }
    let(:klass) { Class.new }

    let(:block) do
      proc do
        namespace.const_set(:Foo, klass)
        namespace.const_set(:Foo, klass)
      end
    end

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Kernel::SilenceWarnings.call`" do
      expect(described_class::SilenceWarnings)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, block]) }

      described_class.silence_warnings(&block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Kernel::SilenceWarnings.call` value" do
      expect(described_class.silence_warnings(&block)).to eq(described_class::SilenceWarnings.call(&block))
    end
  end
end
