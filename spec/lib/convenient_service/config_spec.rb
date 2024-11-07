# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Config, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Helpers::IgnoringException

    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule
    include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::DelegateTo

    subject { described_class }

    context "when included" do
      subject { config }

      let(:config) do
        Module.new.tap do |mod|
          mod.module_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(ConvenientService::Dependencies::Extractions::ActiveSupportConcern::Concern) }

      example_group "generated methods" do
        example_group "class methods" do
          # rubocop:disable RSpec/ExampleLength
          describe ".eval_included_block" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    :included_value
                  end
                end
              end
            end

            let(:klass) { Class.new }

            it "includes `ConvenientService::Core`" do
              expect { config.eval_included_block(klass) }.to change { klass.include?(ConvenientService::Core) }.from(false).to(true)
            end

            it "calls `super`" do
              expect(config.eval_included_block(klass)).to eq(:included_value)
            end

            it "sets `options` as `default_options` inside `included` block" do
              config =
                Module.new.tap do |mod|
                  mod.module_exec(self, described_class) do |example, mod|
                    include mod

                    default_options do
                      [:foo, :bar]
                    end

                    included do
                      example.instance_exec(options) do |options|
                        expect(options).to eq(::Set[:foo, :bar])
                      end
                    end
                  end
                end

              config.eval_included_block(klass)
            end

            it "reset `options` outside `included` block" do
              config =
                Module.new.tap do |mod|
                  mod.module_exec(self, described_class) do |example, mod|
                    include mod

                    default_options do
                      [:foo, :bar]
                    end

                    included do
                    end
                  end
                end

              config.eval_included_block(klass)

              expect(klass.options).to eq(Set.new)
            end

            context "when `included` block raises exception" do
              it "reset `options`" do
                config =
                  Module.new.tap do |mod|
                    mod.module_exec(self, described_class) do |example, mod|
                      include mod

                      default_options do
                        [:foo, :bar]
                      end

                      included do
                        raise ArgumentError
                      end
                    end
                  end

                ignoring_exception(ArgumentError) { config.eval_included_block(klass) }

                expect(klass.options).to eq(Set.new)
              end
            end
          end
          # rubocop:enable RSpec/ExampleLength

          describe ".with" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod

                  default_options do
                    [:foo, :bar]
                  end
                end
              end
            end

            let(:config_copy) { config.with }

            specify do
              expect { config_copy }
                .to delegate_to(config, :dup)
                .without_arguments
            end

            it "returns `config` copy" do
              expect(config_copy).to include(described_class)
            end

            example_group "`config` copy" do
              describe ".base" do
                it "returns original `config`" do
                  expect(config_copy.base).to eq(config)
                end
              end

              describe ".options" do
                context "when `config` copy was created without `options`" do
                  it "returns original `config` `options`" do
                    expect(config_copy.options).to eq(config.options)
                  end
                end

                context "when `config` copy was created with `options`" do
                  let(:config_copy) { config.with(options) }
                  let(:options) { [:baz, :qux] }

                  it "returns original `config` `options` merged with those additional `options`" do
                    expect(config_copy.options).to eq(config.options.dup.merge(options))
                  end

                  specify do
                    expect { config_copy }
                      .to delegate_to(ConvenientService::Config::Commands::NormalizeOptions, :call)
                      .with_arguments(options: [options])
                  end

                  context "when `config` copy was created with variable `options`" do
                    let(:config_copy) { config.with(*options) }
                    let(:options) { [:baz, :qux] }

                    it "returns original `config` `options` merged with those additional `options`" do
                      expect(config_copy.options).to eq(config.options.dup.merge(options))
                    end

                    specify do
                      expect { config_copy }
                        .to delegate_to(ConvenientService::Config::Commands::NormalizeOptions, :call)
                        .with_arguments(options: options)
                    end
                  end
                end
              end
            end
          end

          describe ".without" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod

                  default_options do
                    [:foo, :bar]
                  end
                end
              end
            end

            let(:config_copy) { config.without }

            specify do
              expect { config_copy }
                .to delegate_to(config, :dup)
                .without_arguments
            end

            it "returns `config` copy" do
              expect(config_copy).to include(described_class)
            end

            example_group "`config` copy" do
              describe ".base" do
                it "returns original `config`" do
                  expect(config_copy.base).to eq(config)
                end
              end

              describe ".options" do
                context "when `config` copy was created without `options`" do
                  it "returns original `config` `options`" do
                    expect(config_copy.options).to eq(config.options)
                  end
                end

                context "when `config` copy was created with `options`" do
                  let(:config_copy) { config.without(options) }
                  let(:options) { [:bar] }

                  it "returns original `config` `options` merged with those additional `options`" do
                    expect(config_copy.options).to eq(config.options.dup.subtract(options))
                  end

                  specify do
                    expect { config_copy }
                      .to delegate_to(ConvenientService::Config::Commands::NormalizeOptions, :call)
                      .with_arguments(options: [options])
                  end

                  context "when `config` copy was created with variable `options`" do
                    let(:config_copy) { config.without(*options) }
                    let(:options) { [:bar] }

                    it "returns original `config` `options` merged with those additional `options`" do
                      expect(config_copy.options).to eq(config.options.dup.subtract(options))
                    end

                    specify do
                      expect { config_copy }
                        .to delegate_to(ConvenientService::Config::Commands::NormalizeOptions, :call)
                        .with_arguments(options: options)
                    end
                  end
                end
              end
            end
          end

          describe ".without_defaults" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod

                  default_options do
                    [:foo, :bar]
                  end
                end
              end
            end

            let(:config_copy) { config.without_defaults }

            specify do
              expect { config_copy }
                .to delegate_to(config, :dup)
                .without_arguments
            end

            it "returns `config` copy" do
              expect(config_copy).to include(described_class)
            end

            example_group "`config` copy" do
              describe ".base" do
                it "returns original `config`" do
                  expect(config_copy.base).to eq(config)
                end
              end

              describe ".options" do
                it "returns original `config` `options` merged with those additional `options`" do
                  expect(config_copy.options).to eq(Set.new)
                end
              end
            end
          end

          describe ".base" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod
                end
              end
            end

            it "returns `self`" do
              expect(config.base.object_id).to eq(config.object_id)
            end
          end

          describe ".options" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod
                end
              end
            end

            specify do
              expect { config.options }
                .to delegate_to(ConvenientService::Config::Commands::NormalizeOptions, :call)
                .with_arguments(options: config.default_options)
                .and_return_its_value
            end

            specify do
              expect { config.options }
                .to delegate_to(config.default_options, :dup)
            end
          end

          describe ".default_options" do
            let(:config) do
              Module.new.tap do |mod|
                mod.module_exec(described_class) do |mod|
                  include mod
                end
              end
            end

            context "when `block` is NOT passed" do
              it "returns empty set" do
                expect(config.default_options).to eq(Set.new)
              end

              specify do
                expect { config.default_options }.to cache_its_value
              end
            end

            context "when `block` is passed" do
              let(:options) { Set[:foo, :bar] }
              let(:block) { proc { options } }

              specify do
                expect { config.default_options(&block) }
                  .to delegate_to(ConvenientService::Config::Commands::NormalizeOptions, :call)
                  .with_arguments(options: options)
                  .and_return_its_value
              end

              it "sets default options" do
                config.default_options(&block)

                expect(config.default_options).to eq(options)
              end
            end
          end

          describe ".inspect" do
            context "when `config` does NOT have options" do
              let(:config) do
                Module.new.tap do |mod|
                  mod.module_exec(described_class) do |mod|
                    include mod

                    default_options do
                      []
                    end

                    def self.name
                      "Config"
                    end
                  end
                end
              end

              it "returns `config` name" do
                expect(config.inspect).to eq("Config")
              end

              context "when `config` is anonymous" do
                let(:config) do
                  Module.new.tap do |mod|
                    mod.module_exec(described_class) do |mod|
                      include mod

                      default_options do
                        []
                      end
                    end
                  end
                end

                it "returns `config` anonymous name" do
                  expect(config.inspect).to eq("AnonymousConfig")
                end
              end
            end

            context "when `config` has options" do
              let(:config) do
                Module.new.tap do |mod|
                  mod.module_exec(described_class) do |mod|
                    include mod

                    default_options do
                      [:foo, :bar]
                    end

                    def self.name
                      "Config"
                    end
                  end
                end
              end

              it "returns `config` name" do
                expect(config.inspect).to eq("Config.with(:foo, :bar)")
              end

              context "when `config` is anonymous" do
                let(:config) do
                  Module.new.tap do |mod|
                    mod.module_exec(described_class) do |mod|
                      include mod

                      default_options do
                        [:foo, :bar]
                      end
                    end
                  end
                end

                it "returns `config` anonymous name" do
                  expect(config.inspect).to eq("AnonymousConfig.with(:foo, :bar)")
                end
              end
            end
          end

          example_group "comparison" do
            describe "#==" do
              let(:config) do
                Module.new.tap do |mod|
                  mod.module_exec(described_class) do |mod|
                    include mod

                    default_options do
                      [:foo, :bar]
                    end
                  end
                end
              end

              context "when `other` has different class" do
                let(:other) { 42 }

                it "returns `false`" do
                  expect(config == other).to be_nil
                end
              end

              context "when `other` does NOT include `ConvenientService::Config`" do
                let(:other) { Module.new }

                it "returns `false`" do
                  expect(config == other).to eq(false)
                end
              end

              context "when `other` has different `base`" do
                let(:other) do
                  Module.new.tap do |mod|
                    mod.module_exec(described_class) do |mod|
                      include mod
                    end
                  end
                end

                it "returns `false`" do
                  expect(config == other).to eq(false)
                end
              end

              context "when `other` has different `options`" do
                let(:other) { config.with(:baz, :qux) }

                it "returns `false`" do
                  expect(config == other).to eq(false)
                end
              end

              context "when `other` has same attributes" do
                let(:other) { config.with(:foo, :bar) }

                it "returns `true`" do
                  expect(config == other).to eq(true)
                end
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
