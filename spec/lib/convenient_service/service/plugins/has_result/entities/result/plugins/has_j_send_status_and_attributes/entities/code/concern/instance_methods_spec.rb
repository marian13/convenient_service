# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern::InstanceMethods do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:code) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(value) }
  let(:value) { :foo }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { code }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "instance methods" do
    example_group "comparisons" do
      describe "#==" do
        context "when `other` is NOT castable" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(code == other).to be_nil
          end
        end

        context "when `other` is castable" do
          context "when `other` has different `value`" do
            let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(:bar) }

            it "returns `false`" do
              expect(code == other).to eq(false)
            end
          end

          context "when `other` has same `value`" do
            let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(:foo) }

            it "returns `true`" do
              expect(code == other).to eq(true)
            end
          end
        end
      end
    end

    example_group "conversions" do
      describe "#to_s" do
        it "returns string representation of `code`" do
          expect(code.to_s).to eq("foo")
        end

        specify do
          expect { code.to_s }.to cache_its_value
        end
      end

      describe "#to_sym" do
        it "returns symbol representation of `code`" do
          expect(code.to_sym).to eq(:foo)
        end

        specify do
          expect { code.to_sym }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
