# frozen_string_literal: true

require "bundler/gem_tasks"

##
# IMPORTANT: All rake tasks listed in this file should be executed from the root folder.
#

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
  success = system command

  ##
  # NOTE: Forces rake to exit immediately if any of its `run' commands return a non-zero status.
  #
  exit(1) unless success
end

task default: :rspec

task :rspec do
  run %(bundle exec rspec --format progress)
  run %(bundle exec appraisal rails_5.2 rspec --format progress --require rails_helper)
  run %(bundle exec appraisal rails_6.0 rspec --format progress --require rails_helper)
  run %(bundle exec appraisal rails_6.1 rspec --format progress --require rails_helper)
  run %(bundle exec appraisal rails_7.0 rspec --format progress --require rails_helper)
  run %(bundle exec appraisal dry rspec --format progress --require dry_helper)
end

task :rubocop do
  run %(bundle exec rubocop --config .rubocop.yml)
end

namespace :coverage do
  task :open do
    run %(open coverage/index.html)
  end

  namespace :lcov do
    task :merge do
      run %(npx --yes lcov-result-merger 'coverage/**/lcov.info' coverage/lcov.info)
    end
  end
end

namespace :deps do
  task :install do
    run %(bundle install)
    run %(bundle exec appraisal install)
  end
end

namespace :docs do
  task :generate do
    run %(bundle exec sdoc lib -T rails -o docs --github)
  end

  task :open do
    run %(open docs/index.html)
  end
end

namespace :standard do
  task :rspec do
    run %(bundle exec rspec --format progress)
  end
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

namespace :docker do
  task :build do
    run %(docker build . -f docker/2.7/Dockerfile -t convenient_service:2.7)
    run %(docker build . -f docker/3.0/Dockerfile -t convenient_service:3.0)
    run %(docker build . -f docker/3.1/Dockerfile -t convenient_service:3.1)
  end

  namespace :"ruby_2.7" do
    task :build do
      run %(docker build . -f docker/2.7/Dockerfile -t convenient_service:2.7)
    end

    task :bash do
      run %(docker run --rm -it -v $(pwd):/gem convenient_service:2.7 bash)
    end
  end

  namespace :"ruby_3.0" do
    task :build do
      run %(docker build . -f docker/3.0/Dockerfile -t convenient_service:3.0)
    end

    task :bash do
      run %(docker run --rm -it -v $(pwd):/gem convenient_service:3.0 bash)
    end
  end

  namespace :"ruby_3.1" do
    task :build do
      run %(docker build . -f docker/3.1/Dockerfile -t convenient_service:3.1)
    end

    task :bash do
      run %(docker run --rm -it -v $(pwd):/gem convenient_service:3.1 bash)
    end
  end
end
