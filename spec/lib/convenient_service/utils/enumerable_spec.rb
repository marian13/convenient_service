# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Enumerable, type: :standard do
  describe ".find_last" do
    let(:klass) do
      Class.new do
        include Enumerable

        def each(&block)
          yield("foo")
          yield("bar")
          yield("baz")

          self
        end
      end
    end

    let(:enumerable) { klass.new }
    let(:block) { proc { |item| item[0] == "b" } }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Enumerable::FindLast.call`" do
      expect(described_class::FindLast)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[enumerable], {}, block])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.find_last(enumerable, &block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Enumerable::FindLast.call` value" do
      expect(described_class.find_last(enumerable, &block)).to eq(described_class::FindLast.call(enumerable, &block))
    end
  end
end
