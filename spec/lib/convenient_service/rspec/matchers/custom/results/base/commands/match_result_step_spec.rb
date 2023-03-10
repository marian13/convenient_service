# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Commands::MatchResultStep do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(result: result, step: step) }

      let(:service) do
        Class.new do
          include ConvenientService::Configs::Standard

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      context "when step is NOT valid" do
        let(:step) { 42 }

        let(:error_message) do
          <<~TEXT
            Step `#{step}` is NOT valid.

            `of_step` only accepts a Class or a Symbol. For example:

            be_success.of_step(ReadFileContent)
            be_success.of_step(:validate_path)
            be_success.of_step(:result)

            If you need to confirm that `result` has NO step - use `without_step` instead.

            be_success.without_step
          TEXT
        end

        it "raises `ConvenientService::RSpec::Matchers::Custom::Results::Base::Errors::InvalidStep`" do
          expect { command_result }
            .to raise_error(ConvenientService::RSpec::Matchers::Custom::Results::Base::Errors::InvalidStep)
            .with_message(error_message)
        end
      end

      context "when step is valid" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        context "when step is service" do
          let(:step) { first_step }

          context "when result has NO step" do
            let(:service) do
              Class.new do
                include ConvenientService::Configs::Standard

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(command_result).to eq(false)
            end
          end

          context "when result has step" do
            context "when result step is NOT same as service" do
              let(:service) do
                Class.new do
                  include ConvenientService::Configs::Standard

                  step :result

                  def result
                    success
                  end
                end
              end

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result step is same as service" do
              let(:service) do
                Class.new.tap do |service_class|
                  service_class.class_exec(first_step) do |first_step|
                    include ConvenientService::Configs::Standard

                    step first_step
                  end
                end
              end

              it "returns `true`" do
                expect(command_result).to eq(true)
              end
            end
          end
        end

        context "when step is method" do
          context "when step is NOT `:result` method" do
            let(:step) { :foo }

            context "when result has NO step" do
              let(:service) do
                Class.new do
                  include ConvenientService::Configs::Standard

                  def result
                    success
                  end
                end
              end

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result has step" do
              context "when result step is NOT same as method" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Configs::Standard

                    ##
                    # IMPORTANT:
                    #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
                    #   - It will be reenabled after the introduction of thread-safety specs.
                    #   - Do not use it in production yet.
                    #
                    middlewares :step, scope: :class do
                      use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
                    end

                    step :bar

                    def bar
                      success
                    end
                  end
                end

                it "returns `false`" do
                  expect(command_result).to eq(false)
                end
              end

              context "when result step is same as method" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Configs::Standard

                    ##
                    # IMPORTANT:
                    #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
                    #   - It will be reenabled after the introduction of thread-safety specs.
                    #   - Do not use it in production yet.
                    #
                    middlewares :step, scope: :class do
                      use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
                    end

                    step :foo

                    def foo
                      success
                    end
                  end
                end

                it "returns `true`" do
                  expect(command_result).to eq(true)
                end
              end
            end
          end

          context "when step is `:result` method" do
            let(:step) { :result }

            context "when result has NO step" do
              let(:service) do
                Class.new do
                  include ConvenientService::Configs::Standard

                  def result
                    success
                  end
                end
              end

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result has step" do
              context "when result step is NOT `:result` method" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Configs::Standard

                    ##
                    # IMPORTANT:
                    #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
                    #   - It will be reenabled after the introduction of thread-safety specs.
                    #   - Do not use it in production yet.
                    #
                    middlewares :step, scope: :class do
                      use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
                    end

                    step :foo

                    def foo
                      success
                    end
                  end
                end

                it "returns `false`" do
                  expect(command_result).to eq(false)
                end
              end

              context "when result step is `:result` method" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Configs::Standard

                    step :result

                    def result
                      success
                    end
                  end
                end

                it "returns `true`" do
                  expect(command_result).to eq(true)
                end
              end
            end
          end
        end

        context "when step is `nil`" do
          let(:step) { nil }

          context "when result has NO step" do
            let(:service) do
              Class.new do
                include ConvenientService::Configs::Standard

                def result
                  success
                end
              end
            end

            it "returns `true`" do
              expect(command_result).to eq(true)
            end
          end

          context "when result has step" do
            let(:service) do
              Class.new do
                include ConvenientService::Configs::Standard

                step :result

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(command_result).to eq(false)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
