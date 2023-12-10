# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::BacktraceCleaner do
  ##
  # example_group "class methods" do
  #   ##
  #   # NOTE: `.new` is tested indirectly by `add_convenient_service_silencer`.
  #   #
  #   describe ".new" do
  #     # ...
  #   end
  # end
  #
  example_group "instance methods" do
    let(:backtrace_cleaner) { described_class.new }
    let(:backtrace) { ["foo", "convenient_service"] }

    describe "#clean" do
      it "calls super" do
        backtrace_cleaner.clean(backtrace)

        expect(backtrace_cleaner.clean(backtrace)).to eq(["foo"])
      end

      context "when backtrace is `nil`" do
        let(:backtrace) { nil }

        it "returns empty array" do
          expect(backtrace_cleaner.clean(backtrace)).to eq([])
        end

        ##
        # TODO: `it "logs warning message"`.
        #
      end

      context "when exception is raised" do
        let(:backtrace) { Enumerator.new { raise ArgumentError } }

        it "returns original backtrace" do
          expect(backtrace_cleaner.clean(backtrace)).to eq(backtrace)
        end

        ##
        # TODO: `it "logs warning message"`.
        #
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
