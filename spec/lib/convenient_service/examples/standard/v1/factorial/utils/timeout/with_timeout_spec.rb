# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Factorial::Utils::Timeout::WithTimeout, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:util_result) { described_class.call(seconds, &block) }

      let(:seconds) { 5 }
      let(:block) { proc { :foo } }
      let(:block_value) { :foo }

      it "returns struct with `false` as `timeout?` and `block` value as `value`" do
        expect([util_result.timeout?, util_result.value]).to eq([false, block_value])
      end

      specify do
        expect { util_result }
          .to delegate_to(::Timeout, :timeout)
          .with_arguments(seconds, &block)
      end

      context "when `seconds` is `nil`" do
        let(:seconds) { nil }

        it "returns struct with `false` as `timeout?` and `block` value as `value`" do
          expect([util_result.timeout?, util_result.value]).to eq([false, block_value])
        end
      end

      context "when `seconds` is `0`" do
        let(:seconds) { 0 }

        it "returns struct with `true` as `timeout?` and `nil` as `value`" do
          expect([util_result.timeout?, util_result.value]).to eq([true, nil])
        end
      end

      context "when evaluation of `block` value takes too long" do
        let(:seconds) { 1 }
        let(:block) { proc { (sleep 2).then { :foo } } }

        it "returns struct with `true` as `timeout?` and `nil` as `value`" do
          expect([util_result.timeout?, util_result.value]).to eq([true, nil])
        end
      end

      example_group "return `struct`" do
        let(:struct) { util_result }

        it "responds to `timeout?`" do
          expect(struct).to respond_to(:timeout?)
        end

        it "responds to `value`" do
          expect(struct).to respond_to(:value)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
