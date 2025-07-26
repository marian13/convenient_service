# frozen_string_literal: true

##
# @author Rails Team <https://rubyonrails.org>
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
# @see https://github.com/rails/rails/blob/main/activesupport/lib/active_support/backtrace_cleaner.rb
##

require "test_helper"

require "convenient_service"

##
# @internal
#   NOTE:
#     Copied from `rails/rails` without any logic modification.
#     Version: v8.0.2.
#     Wrapped in a namespace `ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner`.
#     Replaced `ActiveSupport::TestCase` to `Minitest::Test`.
#     Replaced `it` to `should`.
#
#   - https://api.rubyonrails.org/v8.0.2/classes/ActiveSupport/BacktraceCleaner.html
#   - https://github.com/rails/rails/blob/v8.0.2/activesupport/test/backtrace_cleaner_test.rb
#   - https://github.com/rails/rails/blob/main/activesupport/test/backtrace_cleaner_test.rb
#   - https://github.com/rails/rails
#
class BacktraceCleanerFilterTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_filter { |line| line.gsub("/my/prefix", "") }
  end

  should "backtrace should filter all lines in a backtrace, removing prefixes" do
    assert_equal \
      ["/my/class.rb", "/my/module.rb"],
      @bc.clean(["/my/prefix/my/class.rb", "/my/prefix/my/module.rb"])
  end

  should "backtrace cleaner should allow removing filters" do
    @bc.remove_filters!
    assert_equal "/my/prefix/my/class.rb", @bc.clean(["/my/prefix/my/class.rb"]).first
  end

  should "backtrace should contain unaltered lines if they don't match a filter" do
    assert_equal "/my/other_prefix/my/class.rb", @bc.clean(["/my/other_prefix/my/class.rb"]).first
  end

  should "#dup also copy filters" do
    copy = @bc.dup
    @bc.add_filter { |line| line.gsub("/other/prefix/", "") }

    assert_equal "my/class.rb", @bc.clean(["/other/prefix/my/class.rb"]).first
    assert_equal "/other/prefix/my/class.rb", copy.clean(["/other/prefix/my/class.rb"]).first
  end
end

class BacktraceCleanerSilencerTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_silencer { |line| line.include?("mongrel") }
  end

  should "backtrace should not contain lines that match the silencer" do
    assert_equal \
      ["/other/class.rb"],
      @bc.clean(["/mongrel/class.rb", "/other/class.rb", "/mongrel/stuff.rb"])
  end

  should "backtrace cleaner should allow removing silencer" do
    @bc.remove_silencers!
    assert_equal ["/mongrel/stuff.rb"], @bc.clean(["/mongrel/stuff.rb"])
  end

  should "#dup also copy silencers" do
    copy = @bc.dup

    @bc.add_silencer { |line| line.include?("puma") }
    assert_equal [], @bc.clean(["/puma/stuff.rb"])
    assert_equal ["/puma/stuff.rb"], copy.clean(["/puma/stuff.rb"])
  end
end

class BacktraceCleanerMultipleSilencersTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_silencer { |line| line.include?("mongrel") }
    @bc.add_silencer { |line| line.include?("yolo") }
  end

  should "backtrace should not contain lines that match the silencers" do
    assert_equal \
      ["/other/class.rb"],
      @bc.clean(["/mongrel/class.rb", "/other/class.rb", "/mongrel/stuff.rb", "/other/yolo.rb"])
  end

  should "backtrace should only contain lines that match the silencers" do
    assert_equal \
      ["/mongrel/class.rb", "/mongrel/stuff.rb", "/other/yolo.rb"],
      @bc.clean(["/mongrel/class.rb", "/other/class.rb", "/mongrel/stuff.rb", "/other/yolo.rb"],
        :noise)
  end
end

class BacktraceCleanerFilterAndSilencerTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_filter { |line| line.gsub("/mongrel", "") }
    @bc.add_silencer { |line| line.include?("mongrel") }
  end

  should "backtrace should not silence lines that has first had their silence hook filtered out" do
    assert_equal ["/class.rb"], @bc.clean(["/mongrel/class.rb"])
  end
end

class BacktraceCleanerDefaultFilterAndSilencerTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
  end

  should "should format installed gems correctly" do
    backtrace = ["#{Gem.default_dir}/gems/nosuchgem-1.2.3/lib/foo.rb"]
    result = @bc.clean(backtrace, :all)
    assert_equal "nosuchgem (1.2.3) lib/foo.rb", result[0]
  end

  should "should format installed gems not in Gem.default_dir correctly" do
    target_dir = Gem.path.detect { |p| p != Gem.default_dir }
    # skip this test if default_dir is the only directory on Gem.path
    if target_dir
      backtrace = ["#{target_dir}/gems/nosuchgem-1.2.3/lib/foo.rb"]
      result = @bc.clean(backtrace, :all)
      assert_equal "nosuchgem (1.2.3) lib/foo.rb", result[0]
    end
  end

  should "should format gems installed by bundler" do
    backtrace = ["#{Gem.default_dir}/bundler/gems/nosuchgem-1.2.3/lib/foo.rb"]
    result = @bc.clean(backtrace, :all)
    assert_equal "nosuchgem (1.2.3) lib/foo.rb", result[0]
  end

  should "should silence gems from the backtrace" do
    backtrace = ["#{Gem.path[0]}/gems/nosuchgem-1.2.3/lib/foo.rb"]
    result = @bc.clean(backtrace)
    assert_empty result
  end

  should "should silence stdlib" do
    backtrace = ["#{RbConfig::CONFIG["rubylibdir"]}/lib/foo.rb"]
    result = @bc.clean(backtrace)
    assert_empty result
  end

  should "should preserve lines that have a subpath matching a gem path" do
    backtrace = [Gem.default_dir, *Gem.path].map { |path| "/parent#{path}/gems/nosuchgem-1.2.3/lib/foo.rb" }

    assert_equal backtrace, @bc.clean(backtrace)
  end
end

##
# NOTE: Same as above but for `clean_frame`.
#
class BacktraceCleanerFrameFilterTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_filter { |line| line.gsub("/my/prefix", "") }
  end

  should "backtrace should filter all lines in a backtrace, removing prefixes" do
    assert_equal \
      ["/my/class.rb", "/my/module.rb"],
      ["/my/prefix/my/class.rb", "/my/prefix/my/module.rb"].map { |frame| @bc.clean_frame(frame) }
  end

  should "backtrace cleaner should allow removing filters" do
    @bc.remove_filters!
    assert_equal "/my/prefix/my/class.rb", @bc.clean_frame("/my/prefix/my/class.rb")
  end

  should "backtrace should contain unaltered lines if they don't match a filter" do
    assert_equal "/my/other_prefix/my/class.rb", @bc.clean_frame("/my/other_prefix/my/class.rb")
  end

  should "#dup also copy filters" do
    copy = @bc.dup
    @bc.add_filter { |line| line.gsub("/other/prefix/", "") }

    assert_equal "my/class.rb", @bc.clean_frame("/other/prefix/my/class.rb")
    assert_equal "/other/prefix/my/class.rb", copy.clean_frame("/other/prefix/my/class.rb")
  end
end

class BacktraceCleanerFrameSilencerTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_silencer { |line| line.include?("mongrel") }
  end

  should "backtrace should not contain lines that match the silencer" do
    assert_equal \
      [nil, "/other/class.rb", nil],
      ["/mongrel/class.rb", "/other/class.rb", "/mongrel/stuff.rb"].map { |frame| @bc.clean_frame(frame) }
  end

  should "backtrace cleaner should allow removing silencer" do
    @bc.remove_silencers!
    assert_equal "/mongrel/stuff.rb", @bc.clean_frame("/mongrel/stuff.rb")
  end

  should "#dup also copy silencers" do
    copy = @bc.dup

    @bc.add_silencer { |line| line.include?("puma") }
    assert_equal nil, @bc.clean_frame("/puma/stuff.rb")
    assert_equal "/puma/stuff.rb", copy.clean_frame("/puma/stuff.rb")
  end
end

class BacktraceCleanerMultipleFrameSilencersTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_silencer { |line| line.include?("mongrel") }
    @bc.add_silencer { |line| line.include?("yolo") }
  end

  should "backtrace should not contain lines that match the silencers" do
    assert_equal \
      [nil, "/other/class.rb", nil, nil],
      ["/mongrel/class.rb", "/other/class.rb", "/mongrel/stuff.rb", "/other/yolo.rb"].map { |frame| @bc.clean_frame(frame) }
  end

  should "backtrace should only contain lines that match the silencers" do
    assert_equal \
      ["/mongrel/class.rb", nil, "/mongrel/stuff.rb", "/other/yolo.rb"],
      ["/mongrel/class.rb", "/other/class.rb", "/mongrel/stuff.rb", "/other/yolo.rb"].map { |frame| @bc.clean_frame(frame, :noise) }
  end
end

class BacktraceCleanerFrameFilterAndSilencerTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
    @bc.add_filter { |line| line.gsub("/mongrel", "") }
    @bc.add_silencer { |line| line.include?("mongrel") }
  end

  should "backtrace should not silence lines that has first had their silence hook filtered out" do
    assert_equal "/class.rb", @bc.clean_frame("/mongrel/class.rb")
  end
end

class BacktraceCleanerFrameDefaultFilterAndSilencerTest < Minitest::Test
  def setup
    @bc = ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner.new
  end

  should "should format installed gems correctly" do
    backtrace = ["#{Gem.default_dir}/gems/nosuchgem-1.2.3/lib/foo.rb"]
    result = @bc.clean_frame(backtrace.first, :all)
    assert_equal "nosuchgem (1.2.3) lib/foo.rb", result
  end

  should "should format installed gems not in Gem.default_dir correctly" do
    target_dir = Gem.path.detect { |p| p != Gem.default_dir }
    # skip this test if default_dir is the only directory on Gem.path
    if target_dir
      backtrace = ["#{target_dir}/gems/nosuchgem-1.2.3/lib/foo.rb"]
      result = @bc.clean_frame(backtrace.first, :all)
      assert_equal "nosuchgem (1.2.3) lib/foo.rb", result
    end
  end

  should "should format gems installed by bundler" do
    backtrace = ["#{Gem.default_dir}/bundler/gems/nosuchgem-1.2.3/lib/foo.rb"]
    result = @bc.clean_frame(backtrace.first, :all)
    assert_equal "nosuchgem (1.2.3) lib/foo.rb", result
  end

  should "should silence gems from the backtrace" do
    backtrace = ["#{Gem.path[0]}/gems/nosuchgem-1.2.3/lib/foo.rb"]
    result = @bc.clean_frame(backtrace.first)
    assert_nil result
  end

  should "should silence stdlib" do
    backtrace = ["#{RbConfig::CONFIG["rubylibdir"]}/lib/foo.rb"]
    result = @bc.clean_frame(backtrace.first)
    assert_nil result
  end

  should "should preserve lines that have a subpath matching a gem path" do
    backtrace = [Gem.default_dir, *Gem.path].map { |path| "/parent#{path}/gems/nosuchgem-1.2.3/lib/foo.rb" }

    assert_equal backtrace, backtrace.map { |frame| @bc.clean_frame(frame) }
  end
end
