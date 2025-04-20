# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::BacktraceCleaner, type: :standard do
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

    ##
    # NOTE: Tested by `test/lib/convenient_service/dependencies/extractions/active_support_backtrace_cleaner/backtrace_cleaner_test.rb`.
    # NOTE: Tested by `#clean`.
    #
    # describe "#add_gem_filter" do
    #   # ...
    # end
    #
    # NOTE: Tested by `test/lib/convenient_service/dependencies/extractions/active_support_backtrace_cleaner/backtrace_cleaner_test.rb`.
    # NOTE: Tested by `#clean`.
    #
    # describe "#add_gem_silencer" do
    #   # ...
    # end
    #
    # NOTE: Tested by `test/lib/convenient_service/dependencies/extractions/active_support_backtrace_cleaner/backtrace_cleaner_test.rb`.
    # NOTE: Tested by `#clean`.
    #
    # describe "#add_stdlib_silencer" do
    #   # ...
    # end
    #
    # NOTE: Tested by `#clean`.
    #
    # describe "#add_convenient_service_silencer" do
    # end
    #
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
        expect(backtrace_cleaner.clean(["#{ConvenientService.root}/common/foo.rb"])).to eq([])
      end

      it "does NOT silences Convenient Service examples" do
        expect(backtrace_cleaner.clean(["#{ConvenientService.examples_root}/foo.rb"])).to eq(["#{ConvenientService.examples_root}/foo.rb"])
      end

      it "does NOT silences Convenient Service specs" do
        expect(backtrace_cleaner.clean(["#{ConvenientService.spec_root}/foo_spec.rb"])).to eq(["#{ConvenientService.spec_root}/foo_spec.rb"])
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
