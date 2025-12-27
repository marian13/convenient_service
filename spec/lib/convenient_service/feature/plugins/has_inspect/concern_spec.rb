# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::HasInspect::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

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

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    let(:feature_class) do
      Class.new do
        include ConvenientService::Feature::Standard::Config

        def self.name
          "ImportantFeature"
        end
      end
    end

    let(:feature_instance) { feature_class.new }

    describe "#inspect" do
      it "returns `inspect` representation of feature" do
        expect(feature_instance.inspect).to eq("<ImportantFeature>")
      end

      context "when feature class is anonymous" do
        let(:feature_class) do
          Class.new do
            include ConvenientService::Feature::Standard::Config
          end
        end

        it "uses custom class name" do
          expect(feature_instance.inspect).to eq("<AnonymousClass(##{feature_class.object_id})>")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
