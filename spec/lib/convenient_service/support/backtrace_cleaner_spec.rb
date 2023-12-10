# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::BacktraceCleaner do
  ##
  # example_group "class methods" do
  #   ##
  #   # NOTE: `.new` is tested indirectly by `#clean`.
  #   #
  #   describe ".new" do
  #     # ...
  #   end
  # end
  #
  example_group "instance methods" do
    let(:backtrace_cleaner) { described_class.new }

    describe "#clean" do
      ##
      # NOTE: Tested indirectly by the following specs.
      #
      # it "calls super" do
      #   # ...
      # end

      ##
      # - https://github.com/rails/rails/blob/v7.1.2/activesupport/test/clean_backtrace_test.rb#L11https://github.com/rails/rails/blob/v7.1.2/activesupport/test/clean_backtrace_test.rb#L11
      #
      it "does NOT filter prefixes" do
        expect(backtrace_cleaner.clean(["/my/prefix/my/class.rb", "/my/prefix/my/module.rb"])).to eq(["/my/prefix/my/class.rb", "/my/prefix/my/module.rb"])
      end

      ##
      # - https://github.com/rails/rails/blob/v7.1.2/activesupport/test/clean_backtrace_test.rb#L105
      #
      it "does NOT silence gems" do
        expect(backtrace_cleaner.clean(["#{Gem.default_dir}/bundler/gems/nosuchgem-1.2.3/lib/foo.rb"])).to eq(["#{Gem.default_dir}/bundler/gems/nosuchgem-1.2.3/lib/foo.rb"])
      end

      ##
      # - https://github.com/rails/rails/blob/v7.1.2/activesupport/test/clean_backtrace_test.rb#L111
      #
      it "silences stdlib" do
        expect(backtrace_cleaner.clean(["#{RbConfig::CONFIG["rubylibdir"]}/lib/foo.rb"])).to eq([])
      end

      it "silences Convenient Service" do
        expect(backtrace_cleaner.clean(["convenient_service/lib/foo.rb"])).to eq([])
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
