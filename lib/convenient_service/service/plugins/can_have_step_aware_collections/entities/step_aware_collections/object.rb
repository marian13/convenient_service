# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Object < Entities::StepAwareCollections::Base
              ##
              # @api private
              #
              # @!attribute [r] object
              #   @return [Object] Can be any type.
              #
              attr_reader :object

              ##
              # @api private
              #
              # @!attribute [r] propagated_result
              #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              attr_reader :propagated_result

              ##
              # @api private
              #
              # @param object [Object] Can be any type.
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              # @return [void]
              #
              def initialize(object:, organizer:, propagated_result:)
                @object = object
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @param data_key [Symbol, nil]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: nil)
                return propagated_result if propagated_result

                success(data_key || :value => object)
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def all?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def any?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def chain(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def chunk(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def chunk_while(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def collect(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def collect_concat(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def compact(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def count(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def cycle(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def detect(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def drop(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def drop_while(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_cons(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_entry(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_slice(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_with_index(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_with_object(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def entries(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def filter(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def filter_map(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def find(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def find_all(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def find_index(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def first(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def flat_map(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def grep(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def grep_v(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def group_by(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def include?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def inject(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def lazy(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def map(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def max(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def max_by(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def member?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def min(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def min_by(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def minmax(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def minmax_by(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def none?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def one?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def partition(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def reduce(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def reject(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def reverse_each(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def select(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def slice_after(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def slice_before(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def slice_when(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def sort(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def sort_by(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def sum(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def take(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def take_while(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def tally(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def to_a(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def to_h(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def to_set(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def uniq(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def zip(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end
            end
          end
        end
      end
    end
  end
end
