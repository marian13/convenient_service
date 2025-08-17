# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveHelpers::Classes::InThreads, type: :standard do
  example_group "instance methods" do
    describe "#call" do
      let(:command_result) { described_class.call(n, *args, &block) }

      let(:n) { 10 }
      let(:args) { [instance] }
      let(:block) { proc { |instance| instance.increment } }

      let(:klass) do
        Class.new do
          def initialize
            @value = 0
          end

          def increment
            @value += 1
          end
        end
      end

      let(:instance) { klass.new }

      ##
      # NOTE: This is a happy path spec, that is why `sort` is called.
      #
      it "returns values of threads" do
        expect(command_result.sort).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      end

      ##
      # NOTE: Operation inside block must take more than 100ms for Ruby to try to jump between threads.
      # - https://github.com/ruby/ruby/blob/v3_5_0_preview1/thread.c#L115
      #
      # NOTE: Operation inside block must have so-called safe-points for Ruby to try to jump between threads.
      # - https://github.com/ruby/ruby/blob/v3_5_0_preview1/thread.c#L2385
      #
      # NOTE: This spec actually verifies that matcher can catch thread-safety issues.
      # NOTE: This spec may be flaky, that is why it may be commented most of the time.
      # IMPORTANT: Run it each time `in_threads` source is modified.
      #
      context "when `block` operation initiates thread context switching (it takes more than 10ms and has safe-points)" do
        let(:block) do
          proc do |instance|
            sleep(rand(0..0.2))

            Thread.pass

            instance.increment
          end
        end

        it "catches thread-safety issues" do
          expect(command_result).not_to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
