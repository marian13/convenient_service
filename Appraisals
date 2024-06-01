# frozen_string_literal: true

##
# TODO: GitHub wiki for `shouda-matchers`.
#
# IMPORTANT: `shoulda-matchers` loads active support core extensions.
# - https://guides.rubyonrails.org/active_support_core_extensions.html
# - https://apidock.com/rails/v6.1.3.1/Hash/symbolize_keys
#
# This can lead to the false positive tests. For example:
#
#   {"a" => 1}.symbolize_keys
#   # => {:a=>1}
#   # Works well with Active Support
#
#   {"a" => 1}.symbolize_keys
#   # undefined method `symbolize_keys` for {"a"=>1}:Hash (NoMethodError)
#   # Raises for Ruby 3.1 and lower.
#
# To debug who actually requires Active Support, use the following snippet:
#
#   # env.rb (or any other file that is loaded as early as it is possible)
#   def require(path)
#     if path.include?("active_support")
#       print "require \"#{path}\" from \"#{caller.first.gsub(ENV['HOME'], "~")}\"\n\n"
#     end
#
#     super
#   end
##

##
# This wrapper appends Ruby engine and version to the `appraisal_name`.
# This way every Appraisal has a dedicated Gemfile for any combination of Ruby and particular `appraisal_name`.
# For example: `ruby_2.7_rails_5.2`, `ruby_3.0_rails_6.0`, `jruby_9.4_rails_7.0`, etc.
#
# @note Check `gemfiles` directory.
#
# @see https://github.com/thoughtbot/appraisal
# @see https://github.com/thoughtbot/appraisal/blob/v2.4.1/lib/appraisal/appraisal_file.rb#L30
#
# @param appraisal_name [String]
# @param block [Proc]
# @return [void]
#
# @internal
#   Taskfile uses a combination of Ruby engine, Ruby version and `appraisal_name` inside `{{.APPRAISAL_COMMAND}}`.
#
def appraise(appraisal_name, &block)
  super([::RUBY_ENGINE, ::RUBY_VERSION[/\d+.\d+/], appraisal_name].join("_"), &block)
end

appraise "rails_5.2" do
  gem "activemodel", "~> 5.2.0"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_6.0" do
  gem "activemodel", "~> 6.0.0"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_6.1" do
  gem "activemodel", "~> 6.1.0"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_7.0" do
  gem "activemodel", "~> 7.0.0"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_7.1" do
  gem "activemodel", "~> 7.1.0"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_7.2" do
  gem "activemodel", "~> 7.2.0.beta1"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end

appraise "dry" do
  gem "dry-initializer", "~> 3.0.0"

  gem "dry-validation", "~> 1.5.0"

  ##
  # NOTE: Restricts temporarily `dry-configurable` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-configurable/issues/146
  #
  gem "dry-configurable", "~> 0.15.0"

  ##
  # NOTE: Restricts temporarily `dry-schema` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-schema/issues/434
  #
  gem "dry-schema", "~> 1.10.0"

  ##
  # NOTE: Restricts temporarily `dry-core` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-core/issues/73#issuecomment-1279774309
  #
  gem "dry-core", "~> 0.8.0"
end

appraise "amazing_print" do
  gem "amazing_print", "~> 1.5.0"
end

appraise "awesome_print" do
  gem "awesome_print", "~> 1.9.2"
end

##
# NOTE: A combination of all the highest versions of gems. Just for quick hacking in `APPRAISAL=all task console`.
# IMPORTANT: Should not be enforced in CI, since integrity checks between external gems are not the goal of this library (at least for now).
#
appraise "all" do
  gem "activemodel", "~> 7.0.0"

  gem "dry-initializer", "~> 3.0.0"

  gem "dry-validation", "~> 1.5.0"

  ##
  # NOTE: Restricts temporarily `dry-configurable` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-configurable/issues/146
  #
  gem "dry-configurable", "~> 0.15.0"

  ##
  # NOTE: Restricts temporarily `dry-schema` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-schema/issues/434
  #
  gem "dry-schema", "~> 1.10.0"

  ##
  # NOTE: Restricts temporarily `dry-core` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-core/issues/73#issuecomment-1279774309
  #
  gem "dry-core", "~> 0.8.0"

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"

  gem "amazing_print", "~> 1.5.0"

  gem "awesome_print", "~> 1.9.2"
end
