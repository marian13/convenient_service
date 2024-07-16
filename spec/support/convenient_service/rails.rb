# frozen_string_literal: true

ConvenientService::Dependencies.require_assigns_attributes_in_constructor_using_active_model_attribute_assignment_plugin
ConvenientService::Dependencies.require_has_attributes_using_active_model_attributes_plugin
ConvenientService::Dependencies.require_has_j_send_result_params_validations_using_active_model_validations_plugin

ConvenientService::Dependencies.require_rails_examples
ConvenientService::Dependencies.require_rails_examples(version: "v1")

ConvenientService::Dependencies.require_development_tools
