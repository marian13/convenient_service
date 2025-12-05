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
    klass.public_instance_methods.reject { |method_name| Object.ancestors.include?(klass.instance_method(method_name).owner) }.sort
  end

  def protected_instance_methods_of(klass)
    klass.protected_instance_methods.reject { |method_name| Object.ancestors.include?(klass.instance_method(method_name).owner) }.sort
  end

  def private_instance_methods_of(klass)
    klass.private_instance_methods.reject { |method_name| Object.ancestors.include?(klass.instance_method(method_name).owner) }.sort
  end

  if ConvenientService::Dependencies.ruby.jruby?
    ##
    # NOTE: JRuby also returns `[:singleton_method_added, :singleton_method_removed, :singleton_method_undefined]` as public class methods.
    # NOTE: The `yaml_tag` method is added to `Object.singleton_class` by `Psych`.
    #
    def public_class_methods_of(klass)
      (klass.public_methods - [:singleton_method_added, :singleton_method_removed, :singleton_method_undefined]).reject { |method_name| [*Class.ancestors, Object.singleton_class].include?(klass.method(method_name).owner) }.sort
    end
  else
    ##
    # NOTE: The `yaml_tag` method is added to `Object.singleton_class` by `Psych`.
    #
    def public_class_methods_of(klass)
      klass.public_methods.reject { |method_name| [*Class.ancestors, Object.singleton_class].include?(klass.method(method_name).owner) }.sort
    end
  end

  def protected_class_methods_of(klass)
    klass.protected_methods.reject { |method_name| Class.ancestors.include?(klass.method(method_name).owner) }.sort
  end

  ##
  # NOTE: `service_class.private_methods - Class.private_methods` return `[]` in CRuby and [:method_missing] in JRuby.
  #
  def private_class_methods_of(klass)
    klass.private_methods.reject { |method_name| Class.ancestors.include?(klass.method(method_name).owner) }.sort
  end

  def public_singleton_class_methods_of(klass)
    klass.singleton_class.public_methods.reject { |method_name| Class.singleton_class.ancestors.include?(klass.singleton_class.method(method_name).owner) }.sort
  end

  def protected_singleton_class_methods_of(klass)
    klass.singleton_class.protected_methods.reject { |method_name| Class.singleton_class.ancestors.include?(klass.singleton_class.method(method_name).owner) }.sort
  end

  def private_singleton_class_methods_of(klass)
    klass.singleton_class.private_methods.reject { |method_name| Class.singleton_class.ancestors.include?(klass.singleton_class.method(method_name).owner) }.sort
  end

  example_group "service class" do
    ##
    # NOTE: `let(:service_class)` is NOT lifted to the top context to avoid accidental typos inside specs like `message_class` instead of `result_class`.
    #
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

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
          :initialize, # public*
          :initialize_without_middlewares, # private
          :method_missing, # public*
          :respond_to_missing? # public*
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
          :new, # public
          :new_without_commit_config, # private
          :options, # public
          :result, # public
          :result_without_middlewares # private
        ])
      end

      specify do
        expect(protected_class_methods_of(service_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(service_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
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
          :copy, # private
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
          :inspect, # public
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
          :initialize, # public*
          :initialize_without_middlewares, # private
          :method_missing, # public*
          :respond_to_missing? # public*
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
          :new, # public
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

      specify do
        expect(private_class_methods_of(service_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
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
    ##
    # NOTE: `let(:service_class)` is NOT lifted to the top context to avoid accidental typos inside specs like `message_class` instead of `result_class`.
    #
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    let(:result_class) { service_class.result_class }

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
          :initialize, # public*
          :initialize_without_middlewares, # private
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(result_class)).to eq([
          :==, # public,
          :__convenient_service_config__, # private
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(result_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(result_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
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
          :==, # public
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
          :inspect, # public
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
          :strict, # public
          :strict?, # public
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
          :initialize, # public*
          :initialize_without_middlewares, # private
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(result_class)).to eq([
          :==, # public,
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
          :new, # private
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

      specify do
        expect(private_class_methods_of(result_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
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

  example_group "data class" do
    ##
    # NOTE: `let(:service_class)` is NOT lifted to the top context to avoid accidental typos inside specs like `message_class` instead of `result_class`.
    #
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    let(:result_class) { service_class.result_class }
    let(:data_class) { result_class.data_class }

    context "when data class config is NOT committed" do
      specify do
        expect(public_instance_methods_of(data_class)).to eq([
          :==, # public
          :===, # public
          :[], # public
          :__attributes__, # public
          :__empty__?, # public
          :__has_attribute__?, # public
          :__keys__, # public
          :__result__, # private
          :__struct__, # public
          :__value__, # private
          :attributes, # public
          :copy, # private
          :empty?, # public
          :has_attribute?, # public
          :keys, # public
          :result, # private
          :struct, # public
          :to_arguments, # private
          :to_h, # public
          :to_kwargs, # private
          :to_s, # public
          :value # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(data_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(data_class)).to eq([
          :cast, # private
          :cast!, # private
          :initialize, # public*
          :initialize_without_middlewares, # private
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(data_class)).to eq([
          :==, # public,
          :===, # public,
          :__convenient_service_config__, # private
          :cast, # private
          :cast!, # private
          :commit_config!, # public
          :concerns, # public
          :data?, # public
          :data_class?, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(data_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(data_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(data_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(data_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(data_class)).to eq([])
      end
    end

    context "when data class config is committed" do
      before do
        data_class.commit_config!
      end

      specify do
        expect(public_instance_methods_of(data_class)).to eq(
          [
            :==, # public
            :===, # public
            :[], # public
            :__attributes__, # public
            :__empty__?, # public
            :__has_attribute__?, # public
            :__keys__, # public
            :__result__, # private
            :__struct__, # public
            :__value__, # private
            :attributes, # public
            :copy, # private
            :empty?, # public
            :has_attribute?, # public
            :inspect, # public
            :keys, # public
            :result, # private
            :struct, # public
            :to_arguments, # private
            :to_h, # public
            :to_kwargs, # private
            :to_s, # public
            :value # private
          ]
        )
      end

      specify do
        expect(protected_instance_methods_of(data_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(data_class)).to eq([
          :cast, # private
          :cast!, # private
          :initialize, # public*
          :initialize_without_middlewares, # private
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(data_class)).to eq([
          :==, # public,
          :===, # public,
          :__convenient_service_config__, # private
          :cast, # private
          :cast!, # private
          :commit_config!, # public
          :concerns, # public
          :data?, # public
          :data_class?, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(data_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(data_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(data_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(data_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(data_class)).to eq([])
      end
    end
  end

  example_group "message class" do
    ##
    # NOTE: `let(:service_class)` is NOT lifted to the top context to avoid accidental typos inside specs like `message_class` instead of `result_class`.
    #
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    let(:result_class) { service_class.result_class }
    let(:message_class) { result_class.message_class }

    context "when message class config is NOT committed" do
      specify do
        expect(public_instance_methods_of(message_class)).to eq([
          :==, # public
          :===, # public
          :copy, # private
          :empty?, # public
          :result, # private
          :to_arguments, # private
          :to_kwargs, # private
          :to_s, # public
          :value # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(message_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(message_class)).to eq([
          :cast, # private
          :cast!, # private
          :initialize, # public*
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(message_class)).to eq([
          :==, # public,
          :===, # public,
          :__convenient_service_config__, # private
          :cast, # private
          :cast!, # private
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :message?, # public
          :message_class?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(message_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(message_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(message_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(message_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(message_class)).to eq([])
      end
    end

    context "when message class config is committed" do
      before do
        message_class.commit_config!
      end

      specify do
        expect(public_instance_methods_of(message_class)).to eq([
          :==, # public
          :===, # public
          :copy, # private
          :empty?, # public
          :inspect, # public
          :result, # private
          :to_arguments, # private
          :to_kwargs, # private
          :to_s, # public
          :value # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(message_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(message_class)).to eq([
          :cast, # private
          :cast!, # private
          :initialize, # public*
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(message_class)).to eq([
          :==, # public,
          :===, # public,
          :__convenient_service_config__, # private
          :cast, # private
          :cast!, # private
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :message?, # public
          :message_class?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(message_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(message_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(message_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(message_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(message_class)).to eq([])
      end
    end
  end

  example_group "code class" do
    ##
    # NOTE: `let(:service_class)` is NOT lifted to the top context to avoid accidental typos inside specs like `message_class` instead of `result_class`.
    #
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    let(:result_class) { service_class.result_class }
    let(:code_class) { result_class.code_class }

    context "when code class config is NOT committed" do
      specify do
        expect(public_instance_methods_of(code_class)).to eq([
          :==, # public
          :===, # public
          :copy, # private
          :result, # private
          :to_arguments, # private
          :to_kwargs, # private
          :to_s, # public
          :to_sym, # public
          :value # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(code_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(code_class)).to eq([
          :cast, # private
          :cast!, # private
          :initialize, # public*
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(code_class)).to eq([
          :==, # public,
          :===, # public,
          :__convenient_service_config__, # private
          :cast, # private
          :cast!, # private
          :code?, # public
          :code_class?, # public
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(code_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(code_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(code_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(code_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(code_class)).to eq([])
      end
    end

    context "when code class config is committed" do
      before do
        code_class.commit_config!
      end

      specify do
        expect(public_instance_methods_of(code_class)).to eq([
          :==, # public
          :===, # public
          :copy, # private
          :inspect, # public
          :result, # private
          :to_arguments, # private
          :to_kwargs, # private
          :to_s, # public
          :to_sym, # public
          :value # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(code_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(code_class)).to eq([
          :cast, # private
          :cast!, # private
          :initialize, # public*
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(code_class)).to eq([
          :==, # public
          :===, # public
          :__convenient_service_config__, # private
          :cast, # private
          :cast!, # private
          :code?, # public
          :code_class?, # public
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new, # public
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(code_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(code_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(code_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(code_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(code_class)).to eq([])
      end
    end
  end

  example_group "step class" do
    ##
    # NOTE: `let(:service_class)` is NOT lifted to the top context to avoid accidental typos inside specs like `message_class` instead of `result_class`.
    #
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    let(:step_class) { service_class.step_class }

    context "when step class config is NOT committed" do
      specify do
        expect(public_instance_methods_of(step_class)).to eq([
          :==, # public
          :action, # public
          :args, # private
          :code, # public
          :container, # public
          :copy, # private
          :data, # public
          :define!, # private
          :error?, # public
          :extra_kwargs, # private
          :failure?, # public
          :has_organizer?, # private
          :index, # public
          :input_values, # public
          :inputs, # private
          :kwargs, # private
          :message, # public
          :method_result, # public
          :method_result_without_middlewares, # private
          :not_error?, # public
          :not_failure?, # public
          :not_success?, # public
          :organizer, # public
          :output_values, # public
          :outputs, # private
          :params, # private
          :printable_action, # private
          :printable_container, # private
          :result, # public
          :result_without_middlewares, # private
          :save_outputs_in_organizer!, # private
          :service_result, # public
          :service_result_without_middlewares, # private
          :status, # public
          :strict?, # public
          :success?, # public
          :to_args, # private
          :to_arguments, # private
          :to_kwargs, # private
          :to_s, # public
          :unsafe_code, # public
          :unsafe_data, # public
          :unsafe_message, # public
          :with_organizer # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(step_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(step_class)).to eq([
          :calculate_input_values, # private # TODO: Remove.
          :calculate_output_values, # private # TODO: Remove.
          :initialize, # public*
          :method_missing, # public*
          :resolve_params, # private # TODO: Remove.
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(step_class)).to eq([
          :==, # public,
          :__convenient_service_config__, # private
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :middlewares, # public
          :namespace, # private
          :new, # private
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(step_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(step_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(step_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(step_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(step_class)).to eq([])
      end
    end

    context "when step class config is committed" do
      before do
        step_class.commit_config!
      end

      specify do
        expect(public_instance_methods_of(step_class)).to eq([
          :==, # public
          :[],  # public
          :action,  # public
          :args, # private
          :code, # public
          :container, # public
          :copy, # private
          :data, # public
          :define!, # private
          :error?, # public
          :evaluated?, # private
          :extra_kwargs, # private
          :failure?, # public
          :fallback_error_step?, # public
          :fallback_failure_step?, # public
          :fallback_step?, # public
          :fallback_true_step?, # public
          :has_organizer?, # private
          :index, # public
          :input_values, # public
          :inputs, # private
          :inspect, # public
          :internals, # private
          :kwargs, # private
          :mark_as_evaluated!, # private
          :message, # public
          :method, # public
          :method_result, # public
          :method_result_without_middlewares, # private
          :method_step?, # public
          :not_error?, # public
          :not_evaluated?, # private
          :not_failure?, # public
          :not_ok?, # public
          :not_success?, # public
          :ok?, # public
          :organizer, # public
          :output_values, # public
          :outputs, # private
          :params, # private
          :printable_action, # private
          :printable_container, # private
          :result, # public
          :result_step?, # public
          :result_without_middlewares, # private
          :save_outputs_in_organizer!, # private
          :service_class, # private
          :service_result, # public
          :service_result_without_middlewares, # private
          :service_step?, # public
          :status, # public
          :strict?, # public
          :success?, # public
          :to_args, # private
          :to_arguments, # private
          :to_kwargs, # private
          :to_s, # public
          :uc, # public
          :ud, # public
          :um, # public
          :unsafe_code, # public
          :unsafe_data, # public
          :unsafe_message, # public
          :with_organizer # private
        ])
      end

      specify do
        expect(protected_instance_methods_of(step_class)).to eq([])
      end

      specify do
        expect(private_instance_methods_of(step_class)).to eq([
          :calculate_input_values, # private # TODO: Remove.
          :calculate_output_values, # private # TODO: Remove.
          :initialize, # public*
          :method_missing, # public*
          :resolve_params, # private # TODO: Remove.
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_class_methods_of(step_class)).to eq([
          :==, # public
          :__convenient_service_config__, # private
          :after, # public
          :around, # public
          :before, # public
          :callback, # TODO: Remove `callback`, it should NOT be exposed.
          :callbacks,
          :commit_config!, # public
          :concerns, # public
          :entity, # public
          :has_committed_config?, # public
          :internals_class, # private
          :middlewares, # public
          :namespace, # private
          :new, # public
          :new_without_commit_config, # private
          :options, # public
          :proto_entity # private
        ])
      end

      specify do
        expect(protected_class_methods_of(step_class)).to eq([])
      end

      specify do
        expect(private_class_methods_of(step_class)).to eq([
          :method_missing, # public*
          :respond_to_missing? # public*
        ])
      end

      specify do
        expect(public_singleton_class_methods_of(step_class)).to eq([
          :__convenient_service_config__ # private
        ])
      end

      specify do
        expect(protected_singleton_class_methods_of(step_class)).to eq([])
      end

      specify do
        expect(private_singleton_class_methods_of(step_class)).to eq([])
      end
    end
  end

  example_group "Convenient Service module" do
    specify do
      expect(public_instance_methods_of(ConvenientService)).to eq([])
    end

    specify do
      expect(protected_instance_methods_of(ConvenientService)).to eq([])
    end

    specify do
      expect(private_instance_methods_of(ConvenientService)).to eq([])
    end

    specify do
      expect(public_class_methods_of(ConvenientService)).to eq([
        :backtrace_cleaner, # public
        :debug?, # private
        :examples_root, # private
        :lib_root, # private
        :logger, # public
        :raise, # public
        :reraise, # public
        :root, # public
        :spec_root # private
      ])
    end

    specify do
      expect(protected_class_methods_of(ConvenientService)).to eq([])
    end

    specify do
      expect(private_class_methods_of(ConvenientService)).to eq([])
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength
