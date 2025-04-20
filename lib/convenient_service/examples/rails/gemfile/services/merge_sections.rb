# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class MergeSections
            include RailsService::Config

            attribute :header, :string
            attribute :body, :string

            validates :header, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?
            validates :body, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

            def result
              success(merged_sections: "#{header}\n#{body}")
            end
          end
        end
      end
    end
  end
end
