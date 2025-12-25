# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:feature_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { feature_class }

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".stubbed_entries_store" do
      specify do
        expect { feature_class.stubbed_entries_store }
          .to delegate_to(Thread, :current)
          .without_arguments
          .and_return_its_value
      end
    end

    describe ".stubbed_entries" do
      specify do
        expect { feature_class.stubbed_entries }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache, :call)
          .with_arguments(feature: feature_class)
          .and_return_its_value
      end
    end

    describe ".stub_entry" do
      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          entry :main

          def main
            :main_entry_value
          end
        end
      end

      let(:entry_name) { :main }

      specify do
        expect { feature_class.stub_entry(entry_name) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureStub, :new)
          .with_arguments(feature_class: feature_class, entry_name: entry_name)
          .and_return_its_value
      end
    end

    describe ".unstub_entry" do
      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          entry :main

          def main
            :main_entry_value
          end
        end
      end

      let(:entry_name) { :main }

      specify do
        expect { feature_class.unstub_entry(entry_name) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureUnstub, :new)
          .with_arguments(feature_class: feature_class, entry_name: entry_name)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
