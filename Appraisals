# frozen_string_literal: true

##
# TODO: GitHub wiki for `shouda-matchers`.
#
# IMPORTANT: `shoulda-matchers` loads active support core extensions.
# https://guides.rubyonrails.org/active_support_core_extensions.html
# https://apidock.com/rails/v6.1.3.1/Hash/symbolize_keys
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
#
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

appraise "dry" do
  gem "dry-initializer", "~> 3.0.0"

  gem "dry-validation", "~> 1.5.0"

  ##
  # NOTE: Restricts temporarily `dry-configurable` version (dependency of `dry-validation`) until the following issue is resolved:
  # https://github.com/dry-rb/dry-configurable/issues/146
  #
  gem "dry-configurable", "~> 0.15.0"
end

##
# NOTE: A combination of all the highest versions of gems. Just for quick hacking in `task console:all`.
# IMPORTANT: Should not be enforced in CI, since integrity checks between external gems are not the goal of this library (a least for now).
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
  # NOTE: Waits for `should-matchers` full support.
  #
  # gem "shoulda-matchers", "~> 5.0.0"
end
