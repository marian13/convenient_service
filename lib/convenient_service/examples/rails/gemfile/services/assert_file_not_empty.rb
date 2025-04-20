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
          class AssertFileNotEmpty
            include RailsService::Config

            attribute :path, :string

            validates :path, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

            def result
              return failure("File with path `#{path}` is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
