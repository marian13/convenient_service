# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Commands::GenerateStackName, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      let(:result) { described_class.call(scope: scope, method: method, container: container) }

      let(:scope) { :instance }
      let(:method) { :result }
      let(:container) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }
      let(:klass) { service_class }
      let(:service_class) { Class.new }

      context "when `method` does NOT have suffix" do
        let(:method) { :result }
        let(:stack_name) { "#{service_class}::MethodMiddlewares::Instance::Result" }

        it "returns stack name" do
          expect(result).to eq(stack_name)
        end
      end

      context "when `method` has suffix" do
        context "when suffix is `!`" do
          let(:method) { :result! }
          let(:stack_name) { "#{service_class}::MethodMiddlewares::Instance::ResultExclamationMark" }

          it "returns stack name" do
            expect(result).to eq(stack_name)
          end
        end

        context "when suffix is `?`" do
          let(:method) { :result? }
          let(:stack_name) { "#{service_class}::MethodMiddlewares::Instance::ResultQuestionMark" }

          it "returns stack name" do
            expect(result).to eq(stack_name)
          end
        end
      end

      context "when `scope` is NOT camelized" do
        let(:scope) { :notCAMEZILED_scope }
        let(:stack_name) { "#{service_class}::MethodMiddlewares::NotCAMEZILEDScope::Result" }

        it "camelizes `scope`" do
          expect(result).to eq(stack_name)
        end
      end

      context "when `method` is NOT camelized" do
        let(:method) { :notCAMEZILED_method }
        let(:stack_name) { "#{service_class}::MethodMiddlewares::Instance::NotCAMEZILEDMethod" }

        it "camelizes `method`" do
          expect(result).to eq(stack_name)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
