# frozen_string_literal: true

##
# NOTE: Waits for `should-matchers` full support.
#
# require "spec_helper"
#
# require "convenient_service"
#
# RSpec.describe ConvenientService::Common::Plugins::HasConfig::Concern::InstanceMethods do
#   example_group "delegators" do
#     subject { service_instance }
#
#     let(:service_class) do
#       Class.new.tap do |klass|
#         klass.class_exec(described_class) do |mod|
#           include mod
#         end
#       end
#     end
#
#     let(:service_instance) { service_class.new }
#
#     example_group "delegators" do
#       include Shoulda::Matchers::Independent
#
#       it { is_expected.to delegate_method(:config).to(:class) }
#     end
#   end
# end
