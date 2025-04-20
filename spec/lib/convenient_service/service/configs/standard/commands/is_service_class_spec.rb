# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Configs::Standard::Commands::IsServiceClass, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(service_class: service_class) }

      context "when `service_class` is NOT class" do
        let(:service_class) { nil }

        it "returns `nil`" do
          expect(command_result).to be_nil
        end
      end

      context "when `service_class` is class" do
        context "when `service_class` does NOT include `ConvenientService::Service::Configs::Standard`" do
          let(:service_class) { Class.new }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when `service_class` includes `ConvenientService::Service::Configs::Standard`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `service_class` includes `ConvenientService::Service::Configs::Standard` with additional options" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config.with(:rollbacks)

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `service_class` includes `ConvenientService::Service::Configs::Standard` without some options" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config.without(:fallbacks)

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `service_class` includes `ConvenientService::Service::Configs::Standard` without default options" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config.without_defaults

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        ##
        # NOTE: Indirectly ensures that `ConvenientService::Standard::Config::V1` includes `ConvenientService::Service::Configs::Standard` under the hood.
        #
        context "when `service_class` includes `ConvenientService::Service::Configs::Standard::V1`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config::V1

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
