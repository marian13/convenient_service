# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasInstanceProxy::Commands::CreateInstanceProxyClass, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

      subject(:command_result) { described_class.call(target_class: target_class) }

      let(:target_class) { Class.new }

      it "returns `Class` instance" do
        expect(command_result).to be_instance_of(Class)
      end

      example_group "instance_proxy_class" do
        let(:instance_proxy_class) { described_class.call(target_class: target_class) }

        example_group "inheritance" do
          include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

          subject { instance_proxy_class }

          it { is_expected.to be_descendant_of(ConvenientService::Common::Plugins::HasInstanceProxy::Entities::InstanceProxy) }
        end

        example_group "class methods" do
          describe ".target_class" do
            it "returns `target_class` passed to `ConvenientService::Common::Plugins::HasInstanceProxy::Commands::CreateInstanceProxyClass`" do
              expect(instance_proxy_class.target_class).to eq(target_class)
            end
          end

          describe ".==" do
            context "when `other` does NOT respond to `target_class`" do
              let(:other) { 42 }

              it "returns `nil`" do
                expect(instance_proxy_class == other).to be_nil
              end
            end

            context "when `other` has different `target_class`" do
              let(:other) { described_class.call(target_class: Class.new) }

              it "returns `false`" do
                expect(instance_proxy_class == other).to eq(false)
              end
            end

            context "when `other` has same attributes" do
              let(:other) { described_class.call(target_class: target_class) }

              it "returns `true`" do
                expect(instance_proxy_class == other).to eq(true)
              end
            end
          end
        end

        describe "#inspect" do
          it "returns inspect representation" do
            expect(instance_proxy_class.inspect).to eq("#{target_class}::InstanceProxy")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
