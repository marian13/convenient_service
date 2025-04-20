# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Results, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::PrimitiveMatchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { klass }

      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::BeError) }
      it { is_expected.to include_module(described_class::BeFailure) }
      it { is_expected.to include_module(described_class::BeSuccess) }
      it { is_expected.to include_module(described_class::BeNotError) }
      it { is_expected.to include_module(described_class::BeNotFailure) }
      it { is_expected.to include_module(described_class::BeNotSuccess) }
      it { is_expected.to include_module(described_class::BeResult) }
    end
  end
end
