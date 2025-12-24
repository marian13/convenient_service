# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Concern
          include Support::Concern

          included do |service_class|
            service_class.extend ClassMethods

            ##
            # IMPORTANT:
            #   - Initializes `stubbed_results` during the `include Concern` process.
            #   - Tries to enforce thread-safety in such a way.
            #   - https://github.com/ruby/spec/blob/master/core/module/include_spec.rb
            #   - https://github.com/ruby/ruby/blob/master/class.c
            #
            service_class.stubbed_results
          end

          class_methods do
            ##
            # @return [ConvenientService::Support::Cache]
            #
            # @internal
            #   NOTE: `self` is a service class in the current context. For example:
            #
            #   before do
            #     stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShellCommand)
            #       .with_arguments(command: node_available_command)
            #       .to return_result(node_available_status)
            #   end
            #
            #   # Then `self` is `ConvenientService::Examples::Standard::Gemfile::Services::RunShellCommand`.
            #
            def stubbed_results
              Commands::FetchServiceStubbedResultsCache.call(service: self)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::StubbedService]
            #
            def stub_result
              Entities::StubbedService.new(service_class: self)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::UnstubbedService]
            #
            def unstub_result
              Entities::UnstubbedService.new(service_class: self)
            end
          end
        end
      end
    end
  end
end
