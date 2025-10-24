# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength
RSpec.describe "Public interface", type: [:standard, :e2e] do
  def public_instance_methods_of(klass)
    (klass.public_instance_methods - Object.public_instance_methods).sort
  end

  def protected_instance_methods_of(klass)
    (service_class.protected_instance_methods - Object.protected_instance_methods).sort
  end

  def private_instance_methods_of(klass)
    (service_class.private_instance_methods - Object.private_instance_methods).sort
  end

  def public_class_methods_of(klass)
    (klass.public_methods - Class.public_methods).sort
  end

  def protected_class_methods_of(klass)
    (klass.protected_methods - Class.protected_methods).sort
  end

  def private_class_methods_of(klass)
    klass.private_methods - Class.private_methods
  end

  def public_singleton_class_methods_of(klass)
    (klass.singleton_class.public_methods - Class.singleton_class.public_methods).sort
  end

  def protected_singleton_class_methods_of(klass)
    (klass.singleton_class.protected_methods - Class.singleton_class.protected_methods).sort
  end

  def private_singleton_class_methods_of(klass)
    (klass.singleton_class.private_methods - Class.singleton_class.private_methods).sort
  end

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:result_class) { service_class.result_class }

  example_group "service class" do
    context "when service class config is NOT committed" do
      specify do
        expect(public_instance_methods_of(service_class)).to eq([
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
        ])
      end

      specify do
        expect(protected_instance_methods_of(service_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(service_class)).to eq([
          :initialize_without_middlewares # private
        ])
      end

      specify do
        expect(public_class_methods_of(service_class)).to eq([
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
        ])
      end

      specify do
        expect(protected_class_methods_of(service_class)).to eq([])
      end

      if ConvenientService::Dependencies.ruby.jruby?
        specify do
          expect(private_class_methods_of(service_class)).to eq([
            :method_missing # private
          ])
        end
      else
        specify do
          expect(private_class_methods_of(service_class)).to eq([])
        end
      end

      specify do
        expect(public_singleton_class_methods_of(service_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(service_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(service_class)).to eq([])
      end
    end

    context "when service class config is committed" do
      before do
        service_class.commit_config!
      end

      specify do
        expect(public_instance_methods_of(service_class)).to eq([
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
        ])
      end

      specify do
        expect(protected_instance_methods_of(service_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(service_class)).to eq([
          :initialize_without_middlewares # private
        ])
      end

      specify do
        expect(public_class_methods_of(service_class)).to eq([
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
        ])
      end

      specify do
        expect(protected_class_methods_of(service_class)).to eq([])
      end

      if ConvenientService::Dependencies.ruby.jruby?
        specify do
          expect(private_class_methods_of(service_class)).to eq([
            :method_missing # private
          ])
        end
      else
        specify do
          expect(private_class_methods_of(service_class)).to eq([])
        end
      end

      specify do
        expect(public_singleton_class_methods_of(service_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(service_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(service_class)).to eq([])
      end
    end
  end

  example_group "result class" do
    context "when result class config is NOT committed" do
      specify do
        expect(public_instance_methods_of(result_class)).to eq([
          :code, # public
          :code_without_middlewares, # private
          :data, # public
          :data_without_middlewares, # private
          :message, # public
          :message_without_middlewares, # private
          :negated_result, # public
          :negated_result_without_middlewares # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(result_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(result_class)).to eq([
          :initialize_without_middlewares # private
        ])
      end

      specify do
        expect(public_class_methods_of(result_class)).to eq([
          :__convenient_service_config__, # private
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(result_class)).to eq([])
      end

      if ConvenientService::Dependencies.ruby.jruby?
        specify do
          expect(private_class_methods_of(result_class)).to eq([
            :method_missing # private
          ])
        end
      else
        specify do
          expect(private_class_methods_of(result_class)).to eq([])
        end
      end

      specify do
        expect(public_singleton_class_methods_of(result_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(result_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(result_class)).to eq([])
      end
    end

    context "when result class config is committed" do
      before do
        result_class.commit_config!
      end

      specify do
        expect(public_instance_methods_of(result_class)).to eq([
          :[], # public
          :call, # public
          :checked?, # public
          :code, # public
          :code_without_middlewares,
          :copy, # public
          :create_code, # private
          :create_code!, # private
          :create_data, # private
          :create_data!, # private
          :create_message, # private
          :create_message!, # private
          :create_status, # private
          :create_status!, # private
          :data, # public
          :data_without_middlewares, # private
          :deconstruct, # public
          :deconstruct_keys, # public
          :error?, # public
          :extra_kwargs, # private
          :failure?, # public
          :foreign_result_for?, # private
          :from_fallback?, # public
          :from_fallback_error_result?, # public
          :from_fallback_failure_result?, # public
          :from_fallback_result?, # public
          :from_step?, # public
          :internals, # private
          :jsend_attributes, # private
          :message, # public
          :message_without_middlewares, # private
          :negated?, # public
          :negated_result, # public
          :negated_result_without_middlewares, # private
          :not_error?, # public
          :not_failure?, # public
          :not_ok?, # public
          :not_success?, # public
          :ok?, # public
          :original_service, # public
          :own_result_for?, # private
          :parent, # public
          :parents, # public
          :parents_enum, # public
          :service, # public
          :status, # public
          :step, # public
          :stubbed_result?, # public
          :success?, # public
          :to_arguments, # public
          :to_kwargs, # public
          :uc, # public
          :ud, # public
          :um, # public
          :unsafe_code, # public
          :unsafe_data, # public
          :unsafe_message, # public
          :with_error_fallback, # public
          :with_failure_and_error_fallback, # public
          :with_failure_fallback, # public
          :with_fallback, # public
          :with_fallback_for # public
        ])
      end

      specify do
        expect(protected_instance_methods_of(result_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(result_class)).to eq([
          :initialize_without_middlewares # private
        ])
      end

      specify do
        expect(public_class_methods_of(result_class)).to eq([
          :__convenient_service_config__, # private
          :code_class, # private
          :commit_config!, # public
          :concerns, # public
          :data_class, # private
          :entity, # public
          :has_committed_config?,
          :internals_class, # private
          :message_class, # private
          :middlewares, # public
          :namespace, # private
          :new_without_commit_config, # private
          :new_without_initialize, # private
          :options, # public
          :proto_entity, # private
          :status_class # private
        ])
      end

      specify do
        expect(protected_class_methods_of(result_class)).to eq([])
      end

      if ConvenientService::Dependencies.ruby.jruby?
        specify do
          expect(private_class_methods_of(result_class)).to eq([
            :method_missing # private
          ])
        end
      else
        specify do
          expect(private_class_methods_of(result_class)).to eq([])
        end
      end

      specify do
        expect(public_singleton_class_methods_of(result_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(result_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(result_class)).to eq([])
      end
    end
  end

  ##
  # TODO: Result, Data, ...
  ##
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength
