# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasInstanceProxy::Entities::InstanceProxy do
  let(:instance_proxy) { described_class.new(target: target) }
  let(:target) { "foo" }

  example_group "instance methods" do
    describe "#instance_proxy_target" do
      it "returns `target` passed to constructor" do
        expect(instance_proxy.instance_proxy_target).to eq(target)
      end

      it "uses `@__convenient_service_instance_proxy_target__` as instance variable" do
        expect(instance_proxy.instance_proxy_target).to eq(instance_proxy.instance_variable_get(:@__convenient_service_instance_proxy_target__))
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
