# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class LazyEnumerator < Entities::StepAwareEnumerables::Enumerator
              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              alias_method :lazy_enumerator, :object

              if Dependencies.ruby.version >= 3.1
                ##
                # @api public
                #
                # @param enums [Array<Enumerable>]
                # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
                #
                def chain(*enums)
                  casted_enums = enums.map { |collection| cast_step_aware_enumerable(collection) }.map(&:enumerable)

                  with_processing_return_value_as_lazy_enumerator(arguments(*casted_enums)) do |*enums|
                    enumerable.chain(*enums)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def chunk(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.chunk(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def chunk_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.chunk_while(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def collect(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.collect(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def collect_concat(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.collect_concat(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def compact
                with_processing_return_value_as_lazy_enumerator do
                  lazy_enumerator.compact
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def drop(n)
                with_processing_return_value_as_lazy_enumerator(arguments(n)) do |n|
                  lazy_enumerator.drop(n)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def drop_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.drop_while(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def filter(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.filter(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def filter_map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.filter_map(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def find_all(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.find_all(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def flat_map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.flat_map(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param pattern [Object]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def grep(pattern, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(pattern, &iteration_block)) do |pattern, &step_aware_iteration_block|
                  lazy_enumerator.grep(pattern, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param pattern [Object]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def grep_v(pattern, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(pattern, &iteration_block)) do |pattern, &step_aware_iteration_block|
                  lazy_enumerator.grep_v(pattern, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def lazy
                with_processing_return_value_as_lazy_enumerator do
                  lazy_enumerator.lazy
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.map(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def reject(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.reject(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def select(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.select(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def slice_after(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.slice_after(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def slice_before(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.slice_before(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def slice_when(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.slice_when(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def take(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                  lazy_enumerator.take(n, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def take_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.take_while(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def uniq(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.uniq(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param offset [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def with_index(offset = nil, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block), method: :with_index) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.with_index(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def zip(*args, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                    lazy_enumerator.zip(*args, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator(arguments(*args)) do |*args|
                    lazy_enumerator.zip(*args)
                  end
                end
              end

              ##
              # @api private
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def select_exactly(n, &iteration_block)
                with_processing_return_value_as_exactly_lazy_enumerator(n, arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.select(&step_aware_iteration_block)
                end
              end
            end
          end
        end
      end
    end
  end
end
