# frozen_string_literal: true

appraise "rails_5.2" do
  gem "activemodel", "~> 5.2.0"

  gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_6.0" do
  gem "activemodel", "~> 6.0.0"

  gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_6.1" do
  gem "activemodel", "~> 6.1.0"

  gem "shoulda-matchers", "~> 5.0.0"
end

appraise "rails_7.0" do
  gem "activemodel", "~> 7.0.0"

  gem "shoulda-matchers", "~> 5.0.0"
end

appraise "dry" do
  gem "dry-initializer", "~> 3.0.0"

  gem "dry-validation", "~> 1.5.0"
end

##
# NOTE: A combination of all the highest versions of gems. Just for quick hacking in `task console:all'.
# IMPORTANT: Should not be enforced in CI, since integrity checks between external gems are not the goal of this library (a least for now).
#
appraise "all" do
  gem "activemodel", "~> 7.0.0"

  gem "dry-initializer", "~> 3.0.0"

  gem "dry-validation", "~> 1.5.0"

  gem "shoulda-matchers", "~> 5.0.0"
end
