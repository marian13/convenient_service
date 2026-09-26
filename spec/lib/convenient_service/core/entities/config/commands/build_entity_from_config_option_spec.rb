# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Commands::BuildEntityFromConfigOption, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  shared_examples "verify command behavior" do
    example_group "class methods" do
      describe ".call" do
        subject(:command_result) { described_class.call(base_entity: base_entity, option: option, detail_keys: detail_keys) }

        let(:option) { ConvenientService::Config::Entities::Option.new(name: :some_option, enabled: true, **data) }
        let(:data) { {foo: :bar, baz: :qux, quux: :quuz} }
        let(:detail_keys) { [:foo, :baz] }

        context "when `option` is `nil`" do
          let(:option) { nil }

          it "returns original middleware class" do
            expect(command_result).to eq(base_entity)
          end
        end

        context "when `detail_keys` are empty" do
          let(:detail_keys) { [] }

          it "returns original middleware class" do
            expect(command_result).to eq(base_entity)
          end
        end

        context "when `option` data is empty" do
          let(:data) { {} }

          it "returns original middleware class" do
            expect(command_result).to eq(base_entity)
          end
        end

        context "when `detail_keys` are subset of `option` data" do
          let(:detail_keys) { [:foo, :quux] }

          specify do
            expect { command_result }
              .to delegate_to(base_entity, :with)
              .with_arguments(foo: :bar, quux: :quuz)
              .and_return_its_value
          end
        end

        context "when `detail_keys` are superset of `option` data" do
          let(:detail_keys) { [:foo, :quux, :cargo] }

          specify do
            expect { command_result }
              .to delegate_to(base_entity, :with)
              .with_arguments(foo: :bar, quux: :quuz)
              .and_return_its_value
          end
        end
      end
    end
  end

  context "when base entity is concern" do
    it_behaves_like "verify command behavior" do
      let(:base_entity) { Module.new.tap { |mod| mod.include ConvenientService::Concern } }
    end
  end

  context "when base entity is middleware" do
    it_behaves_like "verify command behavior" do
      let(:base_entity) { Class.new(ConvenientService::Middleware) }
    end
  end
end
# rubocop:enable RSpec/NestedGroups
