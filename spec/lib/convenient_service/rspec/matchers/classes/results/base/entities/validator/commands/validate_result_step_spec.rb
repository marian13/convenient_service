# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator::Commands::ValidateResultStep, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(validator: matcher.validator) }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      context "when matcher has NO result" do
        let(:matcher) { be_success }

        it "returns `false`" do
          expect(command_result).to be(false)
        end
      end

      context "when step chain is NOT used" do
        let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

        it "returns `true`" do
          expect(command_result).to be(true)
        end
      end

      context "when step chain is used" do
        let(:matcher) { be_success.of_step(step).tap { |matcher| matcher.matches?(result) } }

        context "when step is NOT valid" do
          let(:step) { 42 }

          let(:exception_message) do
            <<~TEXT
              Step `#{step}` is NOT valid.

              `of_step` only accepts a `Class` or a `Symbol`. For example:

              be_success.of_step(ReadFileContent)
              be_success.of_step(:validate_path)
              be_success.of_step(:result)

              If you need to confirm that `result` has NO step - use `without_step` instead.

              be_success.without_step
            TEXT
          end

          it "raises `ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStep`" do
            expect { command_result }
              .to raise_error(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStep)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStep) { command_result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when step is valid" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

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
                  include ConvenientService::Standard::Config

                  def result
                    success
                  end
                end
              end

              it "returns `false`" do
                expect(command_result).to be(false)
              end
            end

            context "when result has step" do
              context "when result step is NOT same as service" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    step :result

                    def result
                      success
                    end
                  end
                end

                it "returns `false`" do
                  expect(command_result).to be(false)
                end
              end

              context "when result step is same as service" do
                let(:service) do
                  Class.new.tap do |service_class|
                    service_class.class_exec(first_step) do |first_step|
                      include ConvenientService::Standard::Config

                      step first_step
                    end
                  end
                end

                context "when step index chain is NOT used" do
                  it "returns `true`" do
                    expect(command_result).to be(true)
                  end
                end

                context "when step index chain is used" do
                  let(:matcher) { be_success.of_step(step, index: step_index).tap { |matcher| matcher.matches?(result) } }

                  context "when step index is NOT valid" do
                    let(:step_index) { "abc" }

                    let(:exception_message) do
                      <<~TEXT
                        Step index `#{step_index}` is NOT valid.

                        `of_step` only accepts an `Integer` as `index`. For example:

                        be_success.of_step(ReadFileContent, index: 0)
                        be_success.of_step(:validate_path, index: 1)
                        be_success.of_step(:result, index: 2)
                      TEXT
                    end

                    it "raises `ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex`" do
                      expect { command_result }
                        .to raise_error(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex)
                        .with_message(exception_message)
                    end

                    specify do
                      expect { ignoring_exception(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex) { command_result } }
                        .to delegate_to(ConvenientService, :raise)
                    end
                  end

                  context "when step index is valid" do
                    context "when result step index is NOT same as index" do
                      let(:step_index) { 1 }

                      it "returns `false`" do
                        expect(command_result).to be(false)
                      end
                    end

                    context "when result step index is same as index" do
                      let(:step_index) { 0 }

                      it "returns `true`" do
                        expect(command_result).to be(true)
                      end
                    end
                  end
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
                    include ConvenientService::Standard::Config

                    def result
                      success
                    end
                  end
                end

                it "returns `false`" do
                  expect(command_result).to be(false)
                end
              end

              context "when result has step" do
                context "when result step is NOT same as method" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      step :bar

                      def bar
                        success
                      end
                    end
                  end

                  it "returns `false`" do
                    expect(command_result).to be(false)
                  end
                end

                context "when result step is same as method" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      step :foo

                      def foo
                        success
                      end
                    end
                  end

                  context "when step index chain is NOT used" do
                    it "returns `true`" do
                      expect(command_result).to be(true)
                    end
                  end

                  context "when step index chain is used" do
                    let(:matcher) { be_success.of_step(step, index: step_index).tap { |matcher| matcher.matches?(result) } }

                    context "when step index is NOT valid" do
                      let(:step_index) { "abc" }

                      let(:exception_message) do
                        <<~TEXT
                          Step index `#{step_index}` is NOT valid.

                          `of_step` only accepts an `Integer` as `index`. For example:

                          be_success.of_step(ReadFileContent, index: 0)
                          be_success.of_step(:validate_path, index: 1)
                          be_success.of_step(:result, index: 2)
                        TEXT
                      end

                      it "raises `ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex`" do
                        expect { command_result }
                          .to raise_error(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex)
                          .with_message(exception_message)
                      end

                      specify do
                        expect { ignoring_exception(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex) { command_result } }
                          .to delegate_to(ConvenientService, :raise)
                      end
                    end

                    context "when step index is valid" do
                      context "when result step index is NOT same as index" do
                        let(:step_index) { 1 }

                        it "returns `false`" do
                          expect(command_result).to be(false)
                        end
                      end

                      context "when result step index is same as index" do
                        let(:step_index) { 0 }

                        it "returns `true`" do
                          expect(command_result).to be(true)
                        end
                      end
                    end
                  end
                end
              end
            end

            context "when step is `:result` method" do
              let(:step) { :result }

              context "when result has NO step" do
                let(:service) do
                  Class.new do
                    include ConvenientService::Standard::Config

                    def result
                      success
                    end
                  end
                end

                it "returns `false`" do
                  expect(command_result).to be(false)
                end
              end

              context "when result has step" do
                context "when result step is NOT `:result` method" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      step :foo

                      def foo
                        success
                      end
                    end
                  end

                  it "returns `false`" do
                    expect(command_result).to be(false)
                  end
                end

                context "when result step is `:result` method" do
                  let(:service) do
                    Class.new do
                      include ConvenientService::Standard::Config

                      step :result

                      def result
                        success
                      end
                    end
                  end

                  context "when step index chain is NOT used" do
                    it "returns `true`" do
                      expect(command_result).to be(true)
                    end
                  end

                  context "when step index chain is used" do
                    let(:matcher) { be_success.of_step(step, index: step_index).tap { |matcher| matcher.matches?(result) } }

                    context "when step index is NOT valid" do
                      let(:step_index) { "abc" }

                      let(:exception_message) do
                        <<~TEXT
                          Step index `#{step_index}` is NOT valid.

                          `of_step` only accepts an `Integer` as `index`. For example:

                          be_success.of_step(ReadFileContent, index: 0)
                          be_success.of_step(:validate_path, index: 1)
                          be_success.of_step(:result, index: 2)
                        TEXT
                      end

                      it "raises `ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex`" do
                        expect { command_result }
                          .to raise_error(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex)
                          .with_message(exception_message)
                      end

                      specify do
                        expect { ignoring_exception(ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStepIndex) { command_result } }
                          .to delegate_to(ConvenientService, :raise)
                      end
                    end

                    context "when step index is valid" do
                      context "when result step index is NOT same as index" do
                        let(:step_index) { 1 }

                        it "returns `false`" do
                          expect(command_result).to be(false)
                        end
                      end

                      context "when result step index is same as index" do
                        let(:step_index) { 0 }

                        it "returns `true`" do
                          expect(command_result).to be(true)
                        end
                      end
                    end
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
                  include ConvenientService::Standard::Config

                  def result
                    success
                  end
                end
              end

              it "returns `true`" do
                expect(command_result).to be(true)
              end
            end

            context "when result has step" do
              let(:service) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :result

                  def result
                    success
                  end
                end
              end

              it "returns `false`" do
                expect(command_result).to be(false)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
