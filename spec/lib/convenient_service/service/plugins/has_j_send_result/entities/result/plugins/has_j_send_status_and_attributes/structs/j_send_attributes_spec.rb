# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Structs::JSendAttributes, type: :standard do
  example_group "instance methods" do
    describe "#==" do
      let(:service_class) { Class.new }
      let(:service_instance) { service_class.new }

      let(:jsend_attributes) { described_class.new(**params) }
      let(:params) { {service: service_instance, status: :foo, data: {foo: :bar}, message: "foo", code: :foo} }

      context "when `other` has different `service`" do
        let(:other) { described_class.new(**params.merge(service: Object.new)) }

        it "returns `false`" do
          expect(jsend_attributes == other).to eq(false)
        end
      end

      context "when `other` has different `status`" do
        let(:other) { described_class.new(**params.merge(status: :bar)) }

        it "returns `false`" do
          expect(jsend_attributes == other).to eq(false)
        end
      end

      context "when `other` has different `data`" do
        let(:other) { described_class.new(**params.merge(data: {baz: :qux})) }

        it "returns `false`" do
          expect(jsend_attributes == other).to eq(false)
        end
      end

      context "when `other` has different `message`" do
        let(:other) { described_class.new(**params.merge(message: "bar")) }

        it "returns `false`" do
          expect(jsend_attributes == other).to eq(false)
        end
      end

      context "when `other` has different `code`" do
        let(:other) { described_class.new(**params.merge(code: :bar)) }

        it "returns `false`" do
          expect(jsend_attributes == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(**params) }

        it "returns `true`" do
          expect(jsend_attributes == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
