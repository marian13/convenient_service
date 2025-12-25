# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Configs::Standard, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:feature_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(feature_class).to include_module(ConvenientService::Feature::Core) }

      example_group "feature" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Feature::Plugins::CanHaveEntries::Concern,
              ConvenientService::Common::Plugins::HasInstanceProxy::Concern,
              ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Concern,
              ConvenientService::Feature::Plugins::CanHaveRSpecStubbedEntries::Concern
            ]
          end

          it "sets feature concerns" do
            expect(feature_class.concerns.to_a).to eq(concerns)
          end
        end

        example_group ".new middlewares" do
          let(:class_new_middlewares) do
            [
              ConvenientService::Common::Plugins::HasInstanceProxy::Middleware
            ]
          end

          it "sets feature middlewares for `.new`" do
            expect(feature_class.middlewares(:new, scope: :class).to_a).to eq(class_new_middlewares)
          end
        end

        example_group ".trigger middlewares" do
          let(:class_trigger_middlewares) do
            [
              ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware
            ]
          end

          it "sets feature middlewares for `.trigger`" do
            expect(feature_class.middlewares(:trigger, scope: :class).to_a).to eq(class_trigger_middlewares)
          end
        end

        example_group "#trigger middlewares" do
          let(:trigger_middlewares) do
            [
              ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware
            ]
          end

          it "sets feature middlewares for `.trigger`" do
            expect(feature_class.middlewares(:trigger).to_a).to eq(trigger_middlewares)
          end
        end
      end
    end

    context "when included multiple times" do
      let(:feature_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            include mod
          end
        end
      end

      ##
      # NOTE: Check the following discussion for details:
      # - https://github.com/marian13/convenient_service/discussions/43
      #
      it "applies its `included` block only once" do
        expect(feature_class.middlewares(:trigger).to_a.size).to eq(1)
      end
    end
  end

  example_group "class methods" do
    describe ".available_options" do
      let(:available_options) { ConvenientService::Config::Commands::NormalizeOptions.call(options: [:essential, :test, :rspec]) }

      it "returns available options with `:rspec`" do
        expect(described_class.available_options).to eq(available_options)
      end

      it "returns only enabled options" do
        expect(described_class.available_options.to_a.all?(&:enabled?)).to be(true)
      end
    end

    describe ".default_options" do
      ##
      # NOTE: It tested by `test/lib/convenient_service/feature/configs/standard_test.rb`.
      #
      # context "when `RSpec` is NOT loaded" do
      #   it "returns default options without `:rspec`" do
      #     # ...
      #   end
      # end
      ##

      context "when `RSpec` is loaded" do
        let(:default_options) { ConvenientService::Config::Commands::NormalizeOptions.call(options: [:essential, :test, :rspec]) }

        it "returns default options with `:rspec`" do
          expect(described_class.default_options).to eq(default_options)
        end

        it "returns only enabled options" do
          expect(described_class.default_options.to_a.all?(&:enabled?)).to be(true)
        end
      end
    end

    describe ".feature_class?" do
      context "when `feature` is NOT class" do
        let(:feature_class) { 42 }

        it "returns `false`" do
          expect(described_class.feature_class?(feature_class)).to be(false)
        end
      end

      context "when `feature` is class" do
        context "when `feature` is NOT feature class" do
          let(:feature_class) { Class.new }

          it "returns `false`" do
            expect(described_class.feature_class?(feature_class)).to be(false)
          end

          context "when `feature` is entity class" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Standard::Config

                def feature
                  success
                end
              end
            end

            it "returns `false`" do
              expect(described_class.feature_class?(service_class)).to be(false)
            end
          end
        end

        context "when `feature` is feature class" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config

              entry :main

              def main
                :main_entry_value
              end
            end
          end

          it "returns `true`" do
            expect(described_class.feature_class?(feature_class)).to be(true)
          end
        end
      end
    end

    describe ".feature?" do
      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          entry :main

          def main
            :main_entry_value
          end
        end
      end

      let(:feature_instance) { feature_class.new }

      specify do
        expect { described_class.feature?(feature_instance) }
          .to delegate_to(described_class, :feature_class?)
          .with_arguments(feature_class)
          .and_return_its_value
      end
    end
  end

  example_group "comprehensive suite" do
    let(:available_options) { described_class.available_options }
    let(:default_options) { described_class.default_options }

    specify { expect(available_options.dup.subtract(default_options).to_a.map(&:name)).to eq([]) }
    specify { expect(default_options.dup.subtract(available_options).to_a.map(&:name)).to eq([]) }
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
