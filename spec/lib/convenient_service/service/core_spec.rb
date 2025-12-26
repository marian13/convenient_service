# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Core, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(ConvenientService::Core) }
    end
  end

  example_group "instance methods" do
    describe "#to_s" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:service_instance) { service_class.new }

      context "when `format` is NOT passed" do
        it "defaults to `:inspect`" do
          expect { service_instance.to_s }
            .to delegate_to(service_instance, :inspect)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when `format` is passed" do
        context "when `format` is NOT `:inspect`" do
          it "returns string in `Object#to_s` representation" do
            expect(service_instance.to_s(format: :foo)).to match(/#<#<Class:.+?>:.+?>/)
          end
        end

        context "when `format` is `:inspect`" do
          it "returns string in `#inspect` representation" do
            expect { service_instance.to_s(format: :inspect) }
              .to delegate_to(service_instance, :inspect)
              .without_arguments
              .and_return_its_value
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
