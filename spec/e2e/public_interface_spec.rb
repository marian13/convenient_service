# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength
RSpec.describe "Public interface", type: [:standard, :e2e] do
  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:service_instance) { service_class.allocate }

  let(:actual_service_instance_public_methods) { (service_class.public_instance_methods - Object.public_instance_methods).sort }
  let(:actual_service_instance_protected_methods) { (service_class.protected_instance_methods - Object.protected_instance_methods).sort }
  let(:actual_service_instance_private_methods) { service_class.private_instance_methods - Object.private_instance_methods }

  let(:actual_service_class_public_methods) { (service_class.singleton_class.public_instance_methods - Class.methods).sort }
  let(:actual_service_class_protected_methods) { (service_class.singleton_class.protected_instance_methods - Class.protected_instance_methods).sort }
  let(:actual_service_class_private_methods) { service_class.singleton_class.private_instance_methods - Class.private_instance_methods }

  context "when service class config is NOT committed" do
    let(:expected_service_instance_public_methods) do
      [
        :error, # public
        :error_without_middlewares, # private
        :failure, # public
        :failure_without_middlewares, # private
        :fallback_error_result, # public
        :fallback_error_result_without_middlewares, # private
        :fallback_failure_result, # public
        :fallback_failure_result_without_middlewares, # private
        :fallback_result, # public
        :fallback_result_without_middlewares, # private
        :negated_result, # public
        :negated_result_without_middlewares, # private
        :regular_result, # public
        :regular_result_without_middlewares, # private
        :result, # public
        :result_without_middlewares, # private
        :steps_result, # public
        :steps_result_without_middlewares, # private
        :success, # public
        :success_without_middlewares # private
      ]
    end

    let(:expected_service_instance_protected_methods) { [] }

    let(:expected_service_instance_private_methods) do
      [
        :initialize_without_middlewares # private
      ]
    end

    let(:expected_service_class_public_methods) do
      [
        :__convenient_service_config__, # private
        :after, # public
        :after_without_middlewares, # private
        :around, # public
        :around_without_middlewares, # private
        :before, # public
        :before_without_middlewares, # private
        :commit_config!, # public
        :concerns, # public
        :entity, # public
        :has_committed_config?, # public
        :middlewares, # public
        :new_without_commit_config, # private
        :options, # public
        :result, # public
        :result_without_middlewares # private
      ]
    end

    let(:expected_service_class_protected_methods) { [] }

    let(:expected_service_class_private_methods) { [] }

    specify { expect(actual_service_instance_public_methods).to eq(expected_service_instance_public_methods) }
    specify { expect(actual_service_instance_protected_methods).to eq(expected_service_instance_protected_methods) }
    specify { expect(actual_service_instance_private_methods).to eq(expected_service_instance_private_methods) }

    specify { expect(actual_service_class_public_methods).to eq(expected_service_class_public_methods) }
    specify { expect(actual_service_class_protected_methods).to eq(expected_service_class_protected_methods) }
    specify { expect(actual_service_class_private_methods).to eq(expected_service_class_private_methods) }
  end

  context "when service class config is committed" do
    let(:expected_service_instance_public_methods) do
      [
        :call, # public
        :constructor_arguments, # public
        :copy, # public
        :error, # public
        :error_without_middlewares, # private
        :failure, # public
        :failure_without_middlewares, # private
        :fallback_error_result, # public
        :fallback_error_result_without_middlewares, # private
        :fallback_failure_result, # public
        :fallback_failure_result_without_middlewares, # private
        :fallback_result, # public
        :fallback_result_without_middlewares, # private
        :internals, # private
        :negated_result, # public
        :negated_result_without_middlewares, # private
        :recalculate, # public
        :regular_result, # public
        :regular_result_without_middlewares, # private
        :result, # public
        :result_without_middlewares, # private
        :step, # public
        :step_aware_enumerable, # public
        :step_aware_enumerator, # public
        :steps, # public
        :steps_result, # public
        :steps_result_without_middlewares, # private
        :success, # public
        :success_without_middlewares, # private
        :to_args, # public
        :to_arguments, # public
        :to_block, # public
        :to_kwargs # public
      ]
    end

    let(:expected_service_instance_protected_methods) { [] }

    let(:expected_service_instance_private_methods) do
      [
        :initialize_without_middlewares # private
      ]
    end

    let(:expected_service_class_public_methods) do
      [
        :[], # public
        :__convenient_service_config__, # private
        :after, # public
        :after_without_middlewares, # private
        :and_group, # public
        :and_not_group, # public
        :and_not_step, # public
        :and_step, # public
        :around, # public
        :around_without_middlewares, # private
        :before, # public
        :before_without_middlewares, # private
        :call, # public
        :callback, # TODO: Remove `callback`, it should NOT be exposed.
        :callbacks, # public
        :commit_config!, # public
        :concerns, # public
        :else_group, # public
        :elsif_not_step_group, # public
        :elsif_step_group, # public
        :entity, # public
        :error, # public
        :error?, # public
        :failure, # public
        :failure?, # public
        :fallback_error_result, # public
        :fallback_failure_result, # public
        :fallback_result, # public
        :group, # public
        :has_committed_config?, # public
        :if_not_step_group, # public
        :if_step_group, # public
        :inherited, # private
        :internals_class, # private
        :middlewares, # public
        :negated_result, # public
        # :new, # public
        :new_without_commit_config, # private
        :new_without_initialize, # private
        :not_error?, # public
        :not_failure?, # public
        :not_group, # public
        :not_ok?, # public
        :not_step, # public
        :not_success?, # public
        :ok?, # public
        :options, # public
        :or_group, # public
        :or_not_group, # public
        :or_not_step, # public
        :or_step, # public
        :raw, # public
        :result, # public
        :result_class, # private
        :result_without_middlewares, # private
        :step, # public
        :step_class, # private
        :steps, # public
        :stubbed_results, # private
        :success, # public
        :success? # public
      ]
    end

    let(:expected_service_class_protected_methods) { [] }

    let(:expected_service_class_private_methods) { [] }

    before do
      service_class.commit_config!
    end

    specify { expect(actual_service_instance_public_methods).to eq(expected_service_instance_public_methods) }
    specify { expect(actual_service_instance_protected_methods).to eq(expected_service_instance_protected_methods) }
    specify { expect(actual_service_instance_private_methods).to eq(expected_service_instance_private_methods) }

    specify { expect(actual_service_class_public_methods).to eq(expected_service_class_public_methods) }
    specify { expect(actual_service_class_protected_methods).to eq(expected_service_class_protected_methods) }
    specify { expect(actual_service_class_private_methods).to eq(expected_service_class_private_methods) }

    ##
    # TODO: Singleton class.
    ##
  end

  ##
  # TODO: Result, Data, ...
  ##
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength
