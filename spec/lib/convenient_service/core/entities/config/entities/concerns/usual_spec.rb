# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::Concerns::Usual, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::ExtendModule

    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::DelegateTo

    subject { described_class }

    context "when included" do
      subject { concern }

      let(:concern) do
        Module.new.tap do |mod|
          mod.module_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(ConvenientService::Dependencies::Extractions::ActiveSupportConcern::Concern) }

      example_group "generated methods" do
        example_group "class methods" do
          describe ".from" do
            let(:option) { ConvenientService::Config::Entities::Option.new(name: :some_option, enabled: true, **details) }
            let(:details) { {foo: :bar, baz: :qux, quux: :quuz} }
            let(:detail_keys) { [:foo, :baz] }

            specify do
              expect { concern.from(option, *detail_keys) }
                .to delegate_to(ConvenientService::Core::Entities::Config::Commands::BuildEntityFromConfigOption, :call)
                .with_arguments(base_entity: concern, option: option, detail_keys: detail_keys)
                .and_return_its_value
            end
          end

          describe ".with" do
            let(:args) { [:foo] }
            let(:kwargs) { {foo: :bar} }
            let(:block) { proc { :foo } }

            it "returns concern" do
              expect(concern.with(*args, **kwargs, &block)).to eq(concern)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
