# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveEntries::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:feature_class) do
    Class.new do
      include ConvenientService::Feature::Configs::Standard
    end
  end

  let(:feature_instance) { feature_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { feature_class }

      let(:feature_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "instance methods" do
    describe "#trigger" do
      let(:entry_name) { :main }
      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Configs::Standard

          entry :main

          def main(*args, **kwargs, &block)
            :main_entry_value
          end
        end
      end

      specify do
        expect { feature_instance.trigger(entry_name, *args, **kwargs, &block) }
          .to delegate_to(feature_instance.instance_proxy_target, :public_send)
          .with_arguments(entry_name, *args, **kwargs, &block)
          .and_return_its_value
      end
    end
  end

  example_group "class methods" do
    describe ".entry" do
      let(:names) { [:foo, :bar] }
      let(:body) { proc { :foo } }

      specify do
        expect { feature_class.entry(*names, &body) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntries, :call)
          .with_arguments(feature_class: feature_class, names: names, body: body)
          .and_return_its_value
      end
    end

    describe ".trigger" do
      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Configs::Standard

          entry :main

          def main(*args, **kwargs, &block)
            :main_entry_value
          end
        end
      end

      let(:feature_instance) { feature_class.new }

      let(:entry_name) { :main }
      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        allow(feature_class).to receive(:new).and_return(feature_instance)

        expect { feature_class.trigger(entry_name, *args, **kwargs, &block) }
          .to delegate_to(feature_instance, :trigger)
          .with_arguments(entry_name, *args, **kwargs, &block)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
