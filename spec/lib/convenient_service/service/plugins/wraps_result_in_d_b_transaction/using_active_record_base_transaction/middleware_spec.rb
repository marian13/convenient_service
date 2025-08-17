# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# TODO: Gemfile with Rails and SQL database.
#
# require "spec_helper"
#
# require "convenient_service"
#
# RSpec.describe ConvenientService::Service::Plugins::WrapsResultInDBTransaction::UsingActiveRecordBaseTransaction::Middleware, type: :standard do
#   include ConvenientService::RSpec::Matchers::Results
#
#   let(:middleware) { described_class }
#
#   example_group "inheritance" do
#     include ConvenientService::RSpec::Matchers::BeDescendantOf
#
#     subject { middleware }
#
#     it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
#   end
#
#   example_group "class methods" do
#     describe ".intended_methods" do
#       let(:spec) do
#         Class.new(ConvenientService::MethodChainMiddleware) do
#           intended_for :result, scope: :class, entity: :service
#         end
#       end
#
#       it "returns intended methods" do
#         expect(middleware.intended_methods).to eq(spec.intended_methods)
#       end
#     end
#   end
#
#   example_group "instance methods" do
#     describe "#call" do
#       include ConvenientService::RSpec::Helpers::WrapMethod
#       include ConvenientService::RSpec::Matchers::CallChainNext
#
#       subject(:method_value) { method.call }
#
#       let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }
#
#       let(:service_class) do
#         Class.new.tap do |klass|
#           klass.class_exec(middleware) do |middleware|
#             include ConvenientService::Standard::Config
#
#             middlewares :result do
#               use_and_observe middleware
#             end
#
#             def result
#               success(value: "result value")
#             end
#           end
#         end
#       end
#
#       let(:service_instance) { service_class.new }
#
#       ##
#       # NOTE: How does this spec confirm that result is called inside transaction block (shortly, the condition to prove)?
#       #
#       # 1. `method_value` returns "result value" as it is defined in `service_class`. See let above.
#       # 2. Mock for `ActiveRecord::Base.transaction` returns "transaction value". See spec body.
#       # 3. If `method_value` returns "transaction value" instead of success, it confirms the condition to prove.
#       #
#       # TODO: Write a spec that makes real SQL queries and rollbacks them.
#       #
#       it "is called inside `ActiveRecord::Base.transaction`" do
#         allow(ActiveRecord::Base).to receive(:transaction).and_return(service_instance.success(value: "transaction value"))
#
#         expect(method_value).to be_success.with_data(value: "transaction value")
#       end
#
#       specify do
#         expect { method_value }
#           .to call_chain_next.on(method)
#           .and_return_its_value
#       end
#     end
#   end
# end
