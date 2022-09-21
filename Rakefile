# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

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
  #
  system %(echo "$(tput bold)\e[34m#{command}\e[0m$(tput sgr0)")

  ##
  # NOTE: Actually executes the command.
  #
  system command
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
    run %(bundle exec appraisal dry rspec --format progress --require rails_helper)
  end
end
