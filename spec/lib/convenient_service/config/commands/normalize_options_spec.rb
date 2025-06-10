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
        let(:normalized_options) { {} }

        it "returns empty hash" do
          expect(command_result).to eq(normalized_options)
        end
      end

      context "when `options` is array" do
        context "when `options` is empty array" do
          let(:options) { [] }
          let(:normalized_options) { {} }

          it "returns empty hash" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when `options` contains symbols" do
          let(:options) { [:callbacks, :fallbacks, :rollbacks] }

          let(:normalized_options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
              fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            }
          end

          it "returns hash with symbols normalized to enabled options" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when `options` contains arrays" do
          let(:options) { [:callbacks, [:fallbacks], [:rollbacks]] }

          let(:normalized_options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
              fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            }
          end

          it "returns hash with arrays flattened and normalized to enabled options" do
            expect(command_result).to eq(normalized_options)
          end

          context "when `options` contains nested arrays" do
            let(:options) { [:callbacks, [:fallbacks, [:rollbacks]]] }

            let(:exception_message) do
              <<~TEXT
                Option `#{[:fallbacks, [:rollbacks]].inspect}` can NOT be normalized.

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

        context "when `options` contains sets" do
          let(:options) { [:callbacks, Set[:fallbacks], Set[:rollbacks]] }

          let(:normalized_options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
              fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            }
          end

          it "returns hash with sets flattened and normalized to enabled options" do
            expect(command_result).to eq(normalized_options)
          end

          context "when `options` contains nested sets" do
            let(:options) { [:callbacks, Set[:fallbacks, Set[:rollbacks]]] }

            let(:exception_message) do
              <<~TEXT
                Option `#{Set[:fallbacks, Set[:rollbacks]].inspect}` can NOT be normalized.

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

        context "when `options` contains hashes" do
          context "when `options` contains hashes with one key" do
            context "when `options` contains hashes with falsy values" do
              let(:options) { [:callbacks, {fallbacks: false}, {rollbacks: nil}] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                }
              end

              it "returns hash with hashes normalized to disabled options" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when `options` contains hashes with truthy values" do
              let(:options) { [:callbacks, {fallbacks: true}, {rollbacks: 42}] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              end

              it "returns hash with hashes normalized to enabled options" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end

          context "when `options` contains hashes with multiple keys" do
            context "when `options` contains hashes with multiple keys without `:name` key" do
              context "when `options` contains hashes with falsy values" do
                let(:options) { [:callbacks, {fallbacks: false, rollbacks: nil}, {short_syntax: nil, type_safety: false}] }

                let(:normalized_options) do
                  {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                    short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: false),
                    type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: false)
                  }
                end

                it "returns hash with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when `options` contains hashes with truthy values" do
                let(:options) { [:callbacks, {fallbacks: true, rollbacks: 42}, {short_syntax: 42, type_safety: true}] }

                let(:normalized_options) do
                  {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                    short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: true),
                    type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: true)
                  }
                end

                it "returns hash with hashes normalized to enabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end

            context "when `options` contains hashes with multiple keys with `:name` key" do
              context "when `options` contains hashes with multiple keys with `:name` key and without `:enabled` key" do
                let(:options) { [:callbacks, {name: :fallbacks}, {name: :rollbacks}] }

                let(:normalized_options) do
                  {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                  }
                end

                it "returns hash with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when `options` contains hashes with multiple keys with `:name` key and with `:enabled` key" do
                context "when `options` contains hashes with falsy values" do
                  let(:options) { [:callbacks, {name: :fallbacks, enabled: false}, {name: :rollbacks, enabled: nil}] }

                  let(:normalized_options) do
                    {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                    }
                  end

                  it "returns hash with hashes normalized to disabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when `options` contains hashes with truthy values" do
                  let(:options) { [:callbacks, {name: :fallbacks, enabled: true}, {name: :rollbacks, enabled: 42}] }

                  let(:normalized_options) do
                    {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                    }
                  end

                  it "returns hash with hashes normalized to enabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end
            end
          end
        end

        context "when `options` last element is implicit hash" do
          context "when `options` last element has one key" do
            context "when `options` last element value is falsy value" do
              let(:options) { [:callbacks, :fallbacks, rollbacks: false] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                }
              end

              it "returns hash with last element normalized to disabled option" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when `options` last element value is truthy value" do
              let(:options) { [:callbacks, :fallbacks, rollbacks: true] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              end

              it "returns hash with last element normalized to enabled option" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end

          context "when `options` last element has multiple keys" do
            context "when `options` last element does NOT have `:name` key" do
              let(:options) { [:callbacks, fallbacks: true, rollbacks: true] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              end

              it "returns hash with last element normalized to mutliple options" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when `options` last element has `:name` key" do
              let(:options) { [:callbacks, name: :fallbacks, rollbacks: true] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, rollbacks: true)
                }
              end

              it "returns hash with last element normalized to singular option with extra data" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end
        end
      end

      context "when `options` is set" do
        context "when `options` is empty" do
          let(:options) { Set.new }
          let(:normalized_options) { {} }

          it "returns empty hash" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when `options` contains symbols" do
          let(:options) { Set[:callbacks, :fallbacks, :rollbacks] }
          let(:normalized_options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
              fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            }
          end

          it "returns hash with symbols normalized to options" do
            expect(command_result).to eq(normalized_options)
          end
        end

        context "when `options` contains arrays" do
          let(:options) { Set[:callbacks, [:fallbacks], [:rollbacks]] }
          let(:normalized_options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
              fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            }
          end

          it "returns hash with arrays flattened and normalized to options" do
            expect(command_result).to eq(normalized_options)
          end

          context "when `options` contains nested arrays" do
            let(:options) { Set[:callbacks, [:fallbacks, [:rollbacks]]] }

            let(:exception_message) do
              <<~TEXT
                Option `#{[:fallbacks, [:rollbacks]].inspect}` can NOT be normalized.

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

        context "when `options` contains sets" do
          let(:options) { Set[:callbacks, Set[:fallbacks], Set[:rollbacks]] }
          let(:normalized_options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
              fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
              rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
            }
          end

          it "returns hash with sets flattened and normalized to options" do
            expect(command_result).to eq(normalized_options)
          end

          context "when `options` contains nested sets" do
            let(:options) { Set[:callbacks, Set[:fallbacks, Set[:rollbacks]]] }

            let(:exception_message) do
              <<~TEXT
                Option `#{Set[:fallbacks, Set[:rollbacks]].inspect}` can NOT be normalized.

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

        context "when `options` contains hashes" do
          context "when `options` contains hashes with one key" do
            context "when `options` contains hashes with falsy values" do
              let(:options) { Set[:callbacks, {fallbacks: false}, {rollbacks: nil}] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                }
              end

              it "returns hash with hashes normalized to disabled options" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when `options` contains hashes with truthy values" do
              let(:options) { Set[:callbacks, {fallbacks: true}, {rollbacks: 42}] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              end

              it "returns hash with hashes normalized to enabled options" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end

          context "when `options` contains hashes with multiple keys" do
            context "when `options` contains hashes with multiple keys without `:name` key" do
              context "when `options` contains hashes with falsy values" do
                let(:options) { Set[:callbacks, {fallbacks: false, rollbacks: nil}, {short_syntax: nil, type_safety: false}] }

                let(:normalized_options) do
                  {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false),
                    short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: false),
                    type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: false)
                  }
                end

                it "returns hash with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when `options` contains hashes with truthy values" do
                let(:options) { Set[:callbacks, {fallbacks: true, rollbacks: 42}, {short_syntax: 42, type_safety: true}] }

                let(:normalized_options) do
                  {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true),
                    short_syntax: ConvenientService::Config::Entities::Option.new(name: :short_syntax, enabled: true),
                    type_safety: ConvenientService::Config::Entities::Option.new(name: :type_safety, enabled: true)
                  }
                end

                it "returns hash with hashes normalized to enabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end
            end

            context "when `options` contains hashes with multiple keys with `:name` key" do
              context "when `options` contains hashes with multiple keys with `:name` key and without `:enabled` key" do
                let(:options) { Set[:callbacks, {name: :fallbacks}, {name: :rollbacks}] }

                let(:normalized_options) do
                  {
                    callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                    fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                    rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                  }
                end

                it "returns hash with hashes normalized to disabled options" do
                  expect(command_result).to eq(normalized_options)
                end
              end

              context "when `options` contains hashes with multiple keys with `:name` key and with `:enabled` key" do
                context "when `options` contains hashes with falsy values" do
                  let(:options) { Set[:callbacks, {name: :fallbacks, enabled: false}, {name: :rollbacks, enabled: nil}] }

                  let(:normalized_options) do
                    {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                    }
                  end

                  it "returns hash with hashes normalized to disabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end

                context "when `options` contains hashes with truthy values" do
                  let(:options) { Set[:callbacks, {name: :fallbacks, enabled: true}, {name: :rollbacks, enabled: 42}] }

                  let(:normalized_options) do
                    {
                      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                    }
                  end

                  it "returns hash with hashes normalized to enabled options" do
                    expect(command_result).to eq(normalized_options)
                  end
                end
              end
            end
          end
        end

        context "when `options` last element is implicit hash" do
          context "when `options` last element has one key" do
            context "when `options` last element value is falsy value" do
              let(:options) { Set[:callbacks, :fallbacks, rollbacks: false] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: false)
                }
              end

              it "returns hash with last element normalized to disabled option" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when `options` last element value is truthy value" do
              let(:options) { Set[:callbacks, :fallbacks, rollbacks: true] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              end

              it "returns hash with last element normalized to enabled option" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end

          context "when `options` last element has multiple keys" do
            context "when `options` last element does NOT have `:name` key" do
              let(:options) { Set[:callbacks, fallbacks: true, rollbacks: true] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
                  rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
                }
              end

              it "returns hash with last element normalized to mutliple options" do
                expect(command_result).to eq(normalized_options)
              end
            end

            context "when `options` last element has `:name` key" do
              let(:options) { Set[:callbacks, name: :fallbacks, rollbacks: true] }

              let(:normalized_options) do
                {
                  callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
                  fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: false, rollbacks: true)
                }
              end

              it "returns hash with last element normalized to singular option with extra data" do
                expect(command_result).to eq(normalized_options)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
