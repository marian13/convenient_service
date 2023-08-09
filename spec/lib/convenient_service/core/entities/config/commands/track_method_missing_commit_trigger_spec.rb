# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Commands::TrackMethodMissingCommitTrigger do
  example_group "class methods" do
    subject(:command_result) { described_class.call(config: config, trigger: trigger) }

    let(:config) { ConvenientService::Core::Entities::Config.new(klass: service_class) }

    let(:service_class) do
      Class.new do
        include ConvenientService::Core
      end
    end

    describe ".call" do
      context "when `method_missing` trigger is NOT valid" do
        let(:trigger) { ConvenientService::Core::Constants::Triggers::USER }

        it "does NOT raise `ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing`" do
          expect { command_result }.not_to raise_error
        end

        it "does NOT increment `method_missing` commit counter" do
          expect { command_result }.not_to change { config.method_missing_commits_counter.current_value }
        end
      end

      context "when `method_missing` trigger is valid" do
        context "when `method_missing` trigger is `ConvenientService::Core::Constants::Triggers::INSTANCE_METHOD_MISSING`" do
          let(:trigger) { ConvenientService::Core::Constants::Triggers::INSTANCE_METHOD_MISSING }

          before do
            config.method_missing_commits_counter.current_value = config.method_missing_commits_counter.max_value
          end

          context "when `method_missing` counter is NOT incremented" do
            let(:error_message) do
              <<~TEXT
                `#{config.klass}` config is committed too many times from `method_missing`.

                In order to resolve this issue try to commit it manually before usage of any config-dependent method.

                Example 1 (outside class):

                  # Commitment:
                  #{config.klass}.commit_config!

                  # Few lines later - usage:
                  #{config.klass}.result # or whatever method.

                Example 2 (inside class):

                  class #{config.klass}
                    # ...
                    commit_config!

                    step :result # or any other method that becomes available after config commitment.
                  end
              TEXT
            end

            it "raises `ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing`" do
              expect { command_result }
                .to raise_error(ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing)
                .with_message(error_message)
            end
          end

          context "when `method_missing` counter is incremented" do
            before do
              config.method_missing_commits_counter.reset
            end

            it "does NOT raise `ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing`" do
              expect { command_result }.not_to raise_error
            end

            it "increments `method_missing` commit counter" do
              expect { command_result }.to change(config.method_missing_commits_counter, :current_value).from(config.method_missing_commits_counter.current_value).to(config.method_missing_commits_counter.current_value + 1)
            end
          end
        end

        context "when `method_missing` trigger is `ConvenientService::Core::Constants::Triggers::CLASS_METHOD_MISSING`" do
          let(:trigger) { ConvenientService::Core::Constants::Triggers::CLASS_METHOD_MISSING }

          before do
            config.method_missing_commits_counter.current_value = config.method_missing_commits_counter.max_value
          end

          context "when `method_missing` counter is NOT incremented" do
            let(:error_message) do
              <<~TEXT
                `#{config.klass}` config is committed too many times from `method_missing`.

                In order to resolve this issue try to commit it manually before usage of any config-dependent method.

                Example 1 (outside class):

                  # Commitment:
                  #{config.klass}.commit_config!

                  # Few lines later - usage:
                  #{config.klass}.result # or whatever method.

                Example 2 (inside class):

                  class #{config.klass}
                    # ...
                    commit_config!

                    step :result # or any other method that becomes available after config commitment.
                  end
              TEXT
            end

            it "raises `ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing`" do
              expect { command_result }
                .to raise_error(ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing)
                .with_message(error_message)
            end
          end

          context "when `method_missing` counter is incremented" do
            before do
              config.method_missing_commits_counter.reset
            end

            it "does NOT raise `ConvenientService::Core::Entities::Config::Exceptions::TooManyCommitsFromMethodMissing`" do
              expect { command_result }.not_to raise_error
            end

            it "increments `method_missing` commit counter" do
              expect { command_result }.to change(config.method_missing_commits_counter, :current_value).from(config.method_missing_commits_counter.current_value).to(config.method_missing_commits_counter.current_value + 1)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
