# frozen_string_literal: true

require "bundler/gem_tasks"

##
# Prints a shell command and then executes it.
#
def run(command)
  ##
  # NOTE: Prints empty line.
  #
  puts

  ##
  # NOTE: Prints original command in bold blue color.
  # https://stackoverflow.com/a/69648792/12201472
  #
  system %(echo "\033[1;34m#{command}\033[0m")

  ##
  # NOTE: Actually executes the command.
  #
  system command
end

task default: :rspec

task :rspec do
  run %(bundle exec rspec --format progress)
end

task :rubocop do
  run %(bundle exec rubocop --config .rubocop.yml)
end

namespace :"rails_5.2" do
  task :rspec do
    run %(bundle exec appraisal rails_5.2 rspec --format progress --require rails_helper)
  end
end

namespace :"rails_6.0" do
  task :rspec do
    run %(bundle exec appraisal rails_6.0 rspec --format progress --require rails_helper)
  end
end

namespace :"rails_6.1" do
  task :rspec do
    run %(bundle exec appraisal rails_6.1 rspec --format progress --require rails_helper)
  end
end

namespace :"rails_7.0" do
  task :rspec do
    run %(bundle exec appraisal rails_7.0 rspec --format progress --require rails_helper)
  end
end

namespace :dry do
  task :rspec do
    run %(bundle exec appraisal dry rspec --format progress --require dry_helper)
  end
end
