# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Services
            class ValidateCastedParams
              include ConvenientService::Standard::V1::Config

              attr_reader \
                :original_id,
                :original_format,
                :original_title,
                :original_description,
                :original_tags,
                :original_sources

              attr_reader \
                :casted_id,
                :casted_format,
                :casted_title,
                :casted_description,
                :casted_tags,
                :casted_sources

              step :validate_id, in: [:original_id, :casted_id]
              step :validate_format, in: [:original_format, :casted_format]
              step :validate_title, in: [:original_title, :casted_title]
              step :validate_description, in: [:original_description, :casted_description]
              step :validate_tags, in: [:original_tags, :casted_tags]
              step :validate_sources, in: [:original_sources, :casted_sources]

              def initialize(original_params:, casted_params:)
                @original_id = original_params[:id]
                @original_format = original_params[:format]
                @original_title = original_params[:title]
                @original_description = original_params[:description]
                @original_tags = original_params[:tags]
                @original_sources = original_params[:sources]

                @casted_id = casted_params[:id]
                @casted_format = casted_params[:format]
                @casted_title = casted_params[:title]
                @casted_description = casted_params[:description]
                @casted_tags = casted_params[:tags]
                @casted_sources = casted_params[:sources]
              end

              private

              def validate_id
                return error("Failed to cast `#{original_id.inspect}` into `ID`") unless casted_id

                success
              end

              def validate_format
                return error("Failed to cast `#{original_format.inspect}` into `Format`") unless casted_format

                success
              end

              def validate_title
                return error("Failed to cast `#{original_title.inspect}` into `Title`") unless casted_title

                success
              end

              def validate_description
                return error("Failed to cast `#{original_description.inspect}` into `Description`") unless casted_description

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
end
