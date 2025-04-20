# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

ConvenientService::Dependencies.require_development_tools

ConvenientService::Dependencies.require_assigns_attributes_in_constructor_using_active_model_attribute_assignment_plugin
ConvenientService::Dependencies.require_has_attributes_using_active_model_attributes_plugin
ConvenientService::Dependencies.require_active_model_validations_standard_config_option

ConvenientService::Dependencies.require_rails_examples
ConvenientService::Dependencies.require_rails_examples(version: "v1")
