# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class LazyEnumerator < Entities::StepAwareCollections::Enumerator
              ##
              # @api private
              #
              # @!attribute [r] lazy_enumerator
              #   @return [Enumerator::Lazy]
              #
              attr_reader :lazy_enumerator

              ##
              # @api private
              #
              # @!attribute [w] propagated_result
              #   @return [Enumerator::Lazy]
              #
              attr_writer :propagated_result

              ##
              # @api private
              #
              # @param lazy_enumerator [Enumerator::Lazy]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(lazy_enumerator:, organizer:, propagated_result: nil)
                @lazy_enumerator = lazy_enumerator
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              def enumerable
                lazy_enumerator
              end

              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              def enumerator
                lazy_enumerator
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def chunk(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.chunk(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def chunk_while(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.chunk_while(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def collect(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.collect(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def collect_concat(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.collect_concat(&step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def drop(n)
                process_as_lazy_enumerator(n, nil) do |n|
                  lazy_enumerator.drop(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def drop_while(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.drop_while(&step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def eager
                process_as_enumerator do
                  lazy_enumerator.eager
                end
              end

              ##
              # TODO !!! Object.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def enum_for(method = :each, *args, &iteration_block)
                process_as_lazy_enumerator(method, *args, iteration_block) do |method, *args, step_aware_iteration_block|
                  lazy_enumerator.enum_for(method, *args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.filter(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter_map(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.filter_map(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def find_all(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.find_all(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def flat_map(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.flat_map(&step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def force
                process_as_enumerable do
                  lazy_enumerator.force
                end
              end

              ##
              # @param pattern [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def grep(pattern, &iteration_block)
                process_as_lazy_enumerator(pattern, iteration_block) do |pattern, step_aware_iteration_block|
                  lazy_enumerator.grep(pattern, &step_aware_iteration_block)
                end
              end

              ##
              # @param pattern [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def grep_v(pattern, &iteration_block)
                process_as_lazy_enumerator(pattern, iteration_block) do |pattern, step_aware_iteration_block|
                  lazy_enumerator.grep_v(pattern, &step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def lazy
                process_as_lazy_enumerator(nil) do
                  lazy_enumerator
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def map(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.map(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def reject(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.reject(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def select(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.select(&step_aware_iteration_block)
                end
              end

              ##
              # @overload slice_after(pattern)
              #   @param pattern [Object] Can be any type.
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload slice_after(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_after(*args, &iteration_block)
                process_as_lazy_enumerator(*args, iteration_block) do |*args, step_aware_iteration_block|
                  lazy_enumerator.slice_after(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload slice_before(pattern)
              #   @param pattern [Object] Can be any type.
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload slice_before(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_before(*args, &iteration_block)
                process_as_lazy_enumerator(*args, iteration_block) do |*args, step_aware_iteration_block|
                  lazy_enumerator.slice_before(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_when(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.slice_when(&step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def take(n)
                process_as_lazy_enumerator(n, nil) do |n|
                  lazy_enumerator.take(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def take_while(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.take_while(&step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_a
                process_as_enumerable(nil) do
                  lazy_enumerator.to_a
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_set
                process_as_set(nil) do
                  lazy_enumerator.to_set
                end
              end

              ##
              # TODO !!! Object.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_enum(method = :each, *args, &iteration_block)
                if iteration_block
                  process_as_lazy_enumerator(method, *args, iteration_block) do |method, *args, step_aware_iteration_block|
                    lazy_enumerator.to_enum(method, *args, &step_aware_iteration_block)
                  end
                else
                  process_as_lazy_enumerator(nil) do
                    lazy_enumerator.to_enum(method, *args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def uniq(&iteration_block)
                process_as_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.uniq(&step_aware_iteration_block)
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def zip(*args, &iteration_block)
                enumerables = args.map { |collection| cast_step_aware_collection(collection) }.map(&:enumerable)

                if iteration_block
                  process_as_object(*enumerables, iteration_block) do |*args, step_aware_iteration_block|
                    lazy_enumerator.zip(*args, &step_aware_iteration_block)
                  end
                else
                  process_as_lazy_enumerator(*enumerables, nil) do |*args, iteration_block|
                    lazy_enumerator.zip(*args)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
