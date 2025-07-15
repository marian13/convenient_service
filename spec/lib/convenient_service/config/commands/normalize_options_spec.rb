# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Config::Commands::NormalizeOptions, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(options: options) }

      context "when `options` is `nil`" do
        let(:options) { nil }
        let(:normalized_options) { ConvenientService::Config::Entities::OptionCollection.new }

        it "returns empty normlized options" do
          expect(command_result).to eq(normalized_options)
        end
      end

      context "when `options` is array" do
        context "when that array is empty array" do
          let(:options) { [] }
          let(:normalized_options) { ConvenientService::Config::Entities::OptionCollection.new }

          it "returns empty normlized options" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when that array contains symbols" do
          let(:options) { [:callbacks, :fallbacks, :rollbacks] }

          let(:normalized_options) do
            ConvenientService::Config::Entities::OptionCollection.new(
              options: {
                callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
              }
            )
          end

          it "returns options with symbols normalized to enabled options" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when that array contains arrays" do
          context "when that array contains empty arrays" do
            let(:options) { [:callbacks, [], []] }

            let(:normalized_options) do
              ConvenientService::Config::Entities::OptionCollection.new(
                options: {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true)
                }
              )
            end

            it "returns options without empty arrays" do
              expect(command_result).to eq(normalized_options)
            end
          end

          context "when that array contains arrays of symbols" do
            let(:options) { [:callbacks, [:fallbacks, :rollbacks], [:recalculation, :inspect]] }

            let(:normalized_options) do
              ConvenientService::Config::Entities::OptionCollection.new(
                options: {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                  recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                  inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                }
              )
            end

            it "returns options with arrays flattened and symmbols normalized to enabled options" do
              expect(command_result).to eq(normalized_options)
            end
          end

          context "when that array contains arrays of arrays" do
            let(:options) { [:callbacks, [[:fallbacks, :rollbacks], [:recalculation, :inspect]]] }

            let(:exception_message) do
              <<~TEXT
                Option `#{[[:fallbacks, :rollbacks], [:recalculation, :inspect]].inspect}` can NOT be normalized.

                Consider passing `Symbol` or `Hash` instead.
              TEXT
            end

            it "raises `ConvenientService::Config::Exceptions::OptionCanNotBeNormalized`" do
              expect { command_result }
                .to raise_error(ConvenientService::Config::Exceptions::OptionCanNotBeNormalized)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Config::Exceptions::OptionCanNotBeNormalized) { command_result } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when that array contains arrays of hashes" do
            context "when that array contains arrays of hashes with one key" do
              context "when that array contains arrays of hashes with falsy values" do
                let(:options) { [:callbacks, [{fallbacks: false}, {rollbacks: nil}], [{recalculation: false}, {inspect: nil}]] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                      recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false),
                      inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: false)
                    }
                  )
                end

                it "returns options with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when that array contains arrays of hashes with truthy values" do
                let(:options) { [:callbacks, [{fallbacks: true}, {rollbacks: 42}], [{recalculation: true}, {inspect: 42}]] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                      recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                      inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                    }
                  )
                end

                it "returns options with hashes normalized to enabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end

            context "when that array contains arrays of hashes with multiple keys" do
              context "when that array contains arrays of hashes with multiple keys without `:name` key" do
                context "when that array contains arrays of hashes with falsy values" do
                  let(:options) { [:callbacks, [{fallbacks: false, rollbacks: nil}, {short_syntax: nil, type_safety: false}], [{recalculation: false, inspect: nil}, {exception_services_trace: nil, backtrace_cleaner: false}]] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                        rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                        short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: false),
                        type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: false),
                        recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false),
                        inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: false),
                        exception_services_trace: ConvenientService::Config::Entities::Option.new(name: :exception_services_trace, enabled: false),
                        backtrace_cleaner: ConvenientService::Config::Entities::Option.new(name: :backtrace_cleaner, enabled: false)
                      }
                    )
                  end

                  it "returns options with hashes normalized to disabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when that array contains arrays of hashes with truthy values" do
                  let(:options) { [:callbacks, [{fallbacks: true, rollbacks: 42}, {short_syntax: 42, type_safety: true}], [{recalculation: true, inspect: 42}, {exception_services_trace: 42, backtrace_cleaner: true}]] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                        rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                        short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: true),
                        type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: true),
                        recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                        inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true),
                        exception_services_trace: ConvenientService::Config::Entities::Option.new(name: :exception_services_trace, enabled: true),
                        backtrace_cleaner: ConvenientService::Config::Entities::Option.new(name: :backtrace_cleaner, enabled: true)
                      }
                    )
                  end

                  it "returns options with hashes normalized to enabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end

              context "when that array contains arrays of hashes with multiple keys with `:name` key" do
                context "when that array contains arrays of hashes with multiple keys with `:name` key and without `:enabled` key" do
                  let(:options) { [:callbacks, [{name: :fallbacks}, {name: :rollbacks}], [{name: :recalculation}, {name: :inspect}]] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                        rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                        recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false),
                        inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: false)
                      }
                    )
                  end

                  it "returns options with hashes normalized to disabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when that array contains arrays of hashes with multiple keys with `:name` key and with `:enabled` key" do
                  context "when that array contains arrays of hashes with falsy values" do
                    let(:options) { [:callbacks, [{name: :fallbacks, enabled: false}, {name: :rollbacks, enabled: nil}], [{name: :recalculation, enabled: false}, {name: :inspect, enabled: nil}]] }

                    let(:normalized_options) do
                      ConvenientService::Config::Entities::OptionCollection.new(
                        options: {
                          callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                          fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                          rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                          recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false),
                          inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: false)
                        }
                      )
                    end

                    it "returns options with hashes normalized to disabled options" do
                      expect(command_result).to eq(normalized_options)
                    end
                  end

                  context "when that array contains arrays of hashes with truthy values" do
                    let(:options) { [:callbacks, [{name: :fallbacks, enabled: true}, {name: :rollbacks, enabled: 42}], [{name: :recalculation, enabled: true}, {name: :inspect, enabled: 42}]] }

                    let(:normalized_options) do
                      ConvenientService::Config::Entities::OptionCollection.new(
                        options: {
                          callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                          fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                          rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                          recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                          inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                        }
                      )
                    end

                    it "returns options with hashes normalized to enabled options" do
                      expect(command_result).to eq(normalized_options)
                    end
                  end
                end

                context "when that array contains arrays of hashes with multiple keys with `:name` key and with `:enabled` key and extra data" do
                  let(:options) { [:callbacks, [{name: :fallbacks, enabled: false, status: :failure}, {name: :rollbacks, enabled: nil, exception: false}], [{name: :recalculation, enabled: false, status: :failure}, {name: :inspect, enabled: nil, exception: false}]] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, status: :failure),
                        rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false, exception: false),
                        recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false, status: :failure),
                        inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: false, exception: false)
                      }
                    )
                  end

                  it "returns options with hashes normalized to options with extra data" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end
            end
          end

          context "when that array contains arrays where last element is implicit hash" do
            context "when that array contains arrays where last element has one key" do
              context "when that array contains arrays where last element value is falsy value" do
                let(:options) { [:callbacks, [:fallbacks, rollbacks: false], [:recalculation, inspect: false]] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                      recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                      inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: false)
                    }
                  )
                end

                it "returns options with last element normalized to disabled option" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when that array contains arrays where last element value is truthy value" do
                let(:options) { [:callbacks, [:fallbacks, rollbacks: true], [:recalculation, inspect: true]] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                      recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                      inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                    }
                  )
                end

                it "returns options with last element normalized to enabled option" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end

            context "when that array contains arrays where last element has multiple keys" do
              context "when that array contains arrays where last element does NOT have `:name` key" do
                let(:options) { [:callbacks, [fallbacks: true, rollbacks: true], [recalculation: true, inspect: true]] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                      recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                      inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                    }
                  )
                end

                it "returns options with last element normalized to mutliple options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when that array contains arrays where last element has `:name` key" do
                context "when that array contains arrays where last element has `:name` key without `:enabled` key" do
                  let(:options) { [:callbacks, [name: :fallbacks, rollbacks: true], [name: :recalculation, inspect: true]] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, rollbacks: true),
                        recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false, inspect: true)
                      }
                    )
                  end

                  it "returns options with last element normalized to disabled singular option with extra data" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when that array contains arrays where last element has `:name` key with `:enabled` key" do
                  context "when that array contains arrays where last element value is falsy value" do
                    let(:options) { [:callbacks, [name: :fallbacks, enabled: false], [name: :recalculation, enabled: false]] }

                    let(:normalized_options) do
                      ConvenientService::Config::Entities::OptionCollection.new(
                        options: {
                          callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                          fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                          recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false)
                        }
                      )
                    end

                    it "returns options with last element normalized to disabled option" do
                      expect(command_result).to eq(normalized_options)
                    end
                  end

                  context "when that array contains arrays where last element value is truthy value" do
                    let(:options) { [:callbacks, [name: :fallbacks, enabled: true], [name: :recalculation, enabled: true]] }

                    let(:normalized_options) do
                      ConvenientService::Config::Entities::OptionCollection.new(
                        options: {
                          callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                          fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                          recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true)
                        }
                      )
                    end

                    it "returns options with last element normalized to enabled option" do
                      expect(command_result).to eq(normalized_options)
                    end
                  end
                end

                context "when that array contains arrays of hashes with multiple keys with `:name` key and with `:enabled` key and extra data" do
                  let(:options) { [:callbacks, [name: :fallbacks, enabled: false, status: :failure], [name: :recalculation, enabled: false, status: :failure]] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, status: :failure),
                        recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: false, status: :failure)
                      }
                    )
                  end

                  it "returns options with last element normalized to option with extra data" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end
            end
          end

          context "when that array contains arrays of `ConvenientService::Config::Entities::Option` instances" do
            let(:options) do
              [
                :callbacks,
                [
                  ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                ],
                [
                  ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                  ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                ]
              ]
            end

            let(:normalized_options) do
              ConvenientService::Config::Entities::OptionCollection.new(
                options: {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                  recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                  inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                }
              )
            end

            it "returns options with `ConvenientService::Config::Entities::Option` instances normalized to enabled options" do
              expect(command_result).to eq(normalized_options)
            end
          end

          context "when that array contains arrays of `ConvenientService::Config::Entities::OptionCollection` instances" do
            let(:options) do
              [
                :callbacks,
                [
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                    }
                  )
                ],
                [
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                      inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                    }
                  )
                ]
              ]
            end

            let(:normalized_options) do
              ConvenientService::Config::Entities::OptionCollection.new(
                options: {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                  recalculation: ConvenientService::Config::Entities::Option.new(name: :recalculation, enabled: true),
                  inspect: ConvenientService::Config::Entities::Option.new(name: :inspect, enabled: true)
                }
              )
            end

            it "returns options with `ConvenientService::Config::Entities::OptionCollection` instances normalized to enabled options" do
              expect(command_result).to eq(normalized_options)
            end
          end

          context "when that array contains arrays of invalid elements" do
            let(:options) { [:callbacks, [:fallbacks, 42], [:recalculation, 42]] }

            let(:exception_message) do
              <<~TEXT
                Option `#{[:fallbacks, 42].inspect}` can NOT be normalized.

                Consider passing `Symbol` or `Hash` instead.
              TEXT
            end

            it "raises `ConvenientService::Config::Exceptions::OptionCanNotBeNormalized`" do
              expect { command_result }
                .to raise_error(ConvenientService::Config::Exceptions::OptionCanNotBeNormalized)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Config::Exceptions::OptionCanNotBeNormalized) { command_result } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end

        context "when that array contains hashes" do
          context "when that array contains hashes with one key" do
            context "when that array contains hashes with falsy values" do
              let(:options) { [:callbacks, {fallbacks: false}, {rollbacks: nil}] }

              let(:normalized_options) do
                ConvenientService::Config::Entities::OptionCollection.new(
                  options: {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                  }
                )
              end

              it "returns options with hashes normalized to disabled options" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when that array contains hashes with truthy values" do
              let(:options) { [:callbacks, {fallbacks: true}, {rollbacks: 42}] }

              let(:normalized_options) do
                ConvenientService::Config::Entities::OptionCollection.new(
                  options: {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                  }
                )
              end

              it "returns options with hashes normalized to enabled options" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end

          context "when that array contains hashes with multiple keys" do
            context "when that array contains hashes with multiple keys without `:name` key" do
              context "when that array contains hashes with falsy values" do
                let(:options) { [:callbacks, {fallbacks: false, rollbacks: nil}, {short_syntax: nil, type_safety: false}] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                      short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: false),
                      type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: false)
                    }
                  )
                end

                it "returns options with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when that array contains hashes with truthy values" do
                let(:options) { [:callbacks, {fallbacks: true, rollbacks: 42}, {short_syntax: 42, type_safety: true}] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                      short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: true),
                      type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: true)
                    }
                  )
                end

                it "returns options with hashes normalized to enabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end

            context "when that array contains hashes with multiple keys with `:name` key" do
              context "when that array contains hashes with multiple keys with `:name` key and without `:enabled` key" do
                let(:options) { [:callbacks, {name: :fallbacks}, {name: :rollbacks}] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                    }
                  )
                end

                it "returns options with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when that array contains hashes with multiple keys with `:name` key and with `:enabled` key" do
                context "when that array contains hashes with falsy values" do
                  let(:options) { [:callbacks, {name: :fallbacks, enabled: false}, {name: :rollbacks, enabled: nil}] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                        rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                      }
                    )
                  end

                  it "returns options with hashes normalized to disabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when that array contains hashes with truthy values" do
                  let(:options) { [:callbacks, {name: :fallbacks, enabled: true}, {name: :rollbacks, enabled: 42}] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                        rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                      }
                    )
                  end

                  it "returns options with hashes normalized to enabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end

              context "when that array contains hashes with multiple keys with `:name` key and with `:enabled` key and extra data" do
                let(:options) { [:callbacks, {name: :fallbacks, enabled: false, status: :failure}, {name: :rollbacks, enabled: nil, exception: false}] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, status: :failure),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false, exception: false)
                    }
                  )
                end

                it "returns options with hashes normalized to options with extra data" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end
          end
        end

        context "when that array last element is implicit hash" do
          context "when that array last element has one key" do
            context "when that array last element value is falsy value" do
              let(:options) { [:callbacks, :fallbacks, rollbacks: false] }

              let(:normalized_options) do
                ConvenientService::Config::Entities::OptionCollection.new(
                  options: {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                  }
                )
              end

              it "returns options with last element normalized to disabled option" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when that array last element value is truthy value" do
              let(:options) { [:callbacks, :fallbacks, rollbacks: true] }

              let(:normalized_options) do
                ConvenientService::Config::Entities::OptionCollection.new(
                  options: {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                  }
                )
              end

              it "returns options with last element normalized to enabled option" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end

          context "when that array last element has multiple keys" do
            context "when that array last element does NOT have `:name` key" do
              let(:options) { [:callbacks, fallbacks: true, rollbacks: true] }

              let(:normalized_options) do
                ConvenientService::Config::Entities::OptionCollection.new(
                  options: {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                  }
                )
              end

              it "returns options with last element normalized to mutliple options" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when that array last element has `:name` key" do
              context "when that array last element has `:name` key without `:enabled` key" do
                let(:options) { [:callbacks, name: :fallbacks, rollbacks: true] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, rollbacks: true)
                    }
                  )
                end

                it "returns options with last element normalized to disabled singular option with extra data" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when that array last element has `:name` key with `:enabled` key" do
                context "when that array last element value is falsy value" do
                  let(:options) { [:callbacks, name: :fallbacks, enabled: false] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false)
                      }
                    )
                  end

                  it "returns options with last element normalized to disabled option" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when that array last element value is truthy value" do
                  let(:options) { [:callbacks, name: :fallbacks, enabled: true] }

                  let(:normalized_options) do
                    ConvenientService::Config::Entities::OptionCollection.new(
                      options: {
                        callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                        fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true)
                      }
                    )
                  end

                  it "returns options with last element normalized to enabled option" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end

              context "when that array contains hashes with multiple keys with `:name` key and with `:enabled` key and extra data" do
                let(:options) { [:callbacks, name: :fallbacks, enabled: false, status: :failure] }

                let(:normalized_options) do
                  ConvenientService::Config::Entities::OptionCollection.new(
                    options: {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, status: :failure)
                    }
                  )
                end

                it "returns options with last element normalized to option with extra data" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end
          end
        end

        context "when that array contains `ConvenientService::Config::Entities::Option` instances" do
          let(:options) do
            [
              :callbacks,
              ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            ]
          end

          let(:normalized_options) do
            ConvenientService::Config::Entities::OptionCollection.new(
              options: {
                callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
              }
            )
          end

          it "returns options with `ConvenientService::Config::Entities::Option` instances normalized to enabled options" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when that array contains `ConvenientService::Config::Entities::OptionCollection` instances" do
          let(:options) do
            [
              :callbacks,
              ConvenientService::Config::Entities::OptionCollection.new(
                options: {
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              )
            ]
          end

          let(:normalized_options) do
            ConvenientService::Config::Entities::OptionCollection.new(
              options: {
                callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
              }
            )
          end

          it "returns options with `ConvenientService::Config::Entities::OptionCollection` instances normalized to enabled options" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when that array contains invalid elements" do
          let(:options) { [:callbacks, :fallbacks, 42] }

          let(:exception_message) do
            <<~TEXT
              Option `42` can NOT be normalized.

              Consider passing `Symbol` or `Hash` instead.
            TEXT
          end

          it "raises `ConvenientService::Config::Exceptions::OptionCanNotBeNormalized`" do
            expect { command_result }
              .to raise_error(ConvenientService::Config::Exceptions::OptionCanNotBeNormalized)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Config::Exceptions::OptionCanNotBeNormalized) { command_result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
