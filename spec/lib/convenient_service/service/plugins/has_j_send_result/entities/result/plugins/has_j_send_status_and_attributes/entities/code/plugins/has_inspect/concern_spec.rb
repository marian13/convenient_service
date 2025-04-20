# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { code_class }

      let(:code_class) do
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
    describe "#inspect" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def self.name
            "ImportantService"
          end

          def result
            success
          end
        end
      end

      let(:code) { service.result.unsafe_code }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        code.class.commit_config!
      end

      it "returns `inspect` representation of code" do
        expect(code.inspect).to eq("<ImportantService::Result::Code value: :#{code}>")
      end

      context "when service class is anonymous" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        it "uses custom class name" do
          expect(code.inspect).to eq("<AnonymousClass(##{service.object_id})::Result::Code value: :#{code}>")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
