# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# HACK: For some reason, the following spec if NOT passing in JRuby:
#
#   # spec/lib/convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/concern/instance_methods_spec.rb:205
#   RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern::InstanceMethods, type: :standard do
#     include ConvenientService::RSpec::Matchers::DelegateTo
#
#     let(:service_class) do
#       Class.new do
#         include ConvenientService::Standard::Config
#       end
#     end
#
#     let(:service_instance) { service_class.new }
#
#     let(:result_class) { service_class.result_class }
#
#     let(:result_instance) { result_class.new(**params) }
#
#     let(:params) do
#       {
#         service: service_instance,
#         status: status,
#         data: {foo_foo_foo: :bar},
#         message: "foo",
#         code: :foo,
#         **extra_kwargs
#       }
#     end
#
#     let(:status) { :foo }
#
#     let(:extra_kwargs) { {} }
#
#     specify do
#       expect { result_instance.create_data!(params[:data]) }
#         .to delegate_to(result_class.data_class, :cast!)
#           .with_arguments(params[:data])
#           .and_return { |data| data.copy(overrides: {kwargs: {result: result_instance}}) }
#     end
#
#  That is why JRuby has its own version of `delegation_value` method.
#
#  To debug, place the following code inside `delegation_value` method.
#
#     if expected_arguments.args == [{foo_foo_foo: :bar}]
#       binding.pry
#     end
#
#  And run RSpec with `JRUBY_OPTS='--debug'`.
#
return unless ConvenientService::Dependencies.ruby.match?("jruby < 10.1")

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            class Inputs
              ##
              # @api private
              #
              # @return [Object] Can be any type.
              #
              def delegation_value
                return values[:delegation_value] if values.has_key?(:delegation_value)

                values[:delegation_value] =
                  case
                  when expected_arguments.args.any? && expected_arguments.kwargs.any? && expected_arguments.block
                    object.__send__(method, *expected_arguments.args, **expected_arguments.kwargs, &expected_arguments.block)
                  when expected_arguments.args.any? && expected_arguments.kwargs.any? && !expected_arguments.block
                    object.__send__(method, *expected_arguments.args, **expected_arguments.kwargs)
                  when expected_arguments.args.any? && !expected_arguments.kwargs.any? && expected_arguments.block
                    object.__send__(method, *expected_arguments.args, &expected_arguments.block)
                  when !expected_arguments.args.any? && expected_arguments.kwargs.any? && expected_arguments.block
                    object.__send__(method, **expected_arguments.kwargs, &expected_arguments.block)
                  when expected_arguments.args.any? && !expected_arguments.kwargs.any? && !expected_arguments.block
                    object.__send__(method, *expected_arguments.args)
                  when !expected_arguments.args.any? && expected_arguments.kwargs.any? && !expected_arguments.block
                    object.__send__(method, **expected_arguments.kwargs)
                  when !expected_arguments.args.any? && !expected_arguments.kwargs.any? && expected_arguments.block
                    object.__send__(method, &expected_arguments.block)
                  else
                    object.__send__(method)
                  end
              end
            end
          end
        end
      end
    end
  end
end
