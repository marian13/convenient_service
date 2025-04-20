# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Services
          class ValidateUncastedParams
            include ConvenientService::Standard::Config

            attr_reader :id, :format, :title, :description, :tags, :sources

            step :validate_id, in: :id
            step :validate_format, in: :format
            step :validate_title, in: :title
            step :validate_description, in: :description

            def initialize(params:)
              @id = params[:id]
              @format = params[:format]
              @title = params[:title]
              @description = params[:description]
              @tags = params[:tags]
              @sources = params[:sources]
            end

            private

            def validate_id
              return error("ID is NOT present") if Utils::Object.present?(id)
              return error("ID `#{id}` is NOT a valid integer") unless Utils::Integer.safe_parse(id)

              success
            end

            def validate_format
              return error("Format `#{format}` is NOT supported, only JSON is allowed") if format != "json"

              success
            end

            def validate_title
              return error("Title is NOT present") if Utils::Object.present?(title)

              success
            end

            def validate_description
              return error("Description is NOT present") if Utils::Object.present?(description)

              success
            end

            ##
            # TODO:
            #
            def validate_tags
              success
            end

            ##
            # TODO:
            #
            def validate_sources
              success
            end
          end
        end
      end
    end
  end
end
