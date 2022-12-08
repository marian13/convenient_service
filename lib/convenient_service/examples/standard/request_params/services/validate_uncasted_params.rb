# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class ValidateUncastedParams
            include ConvenientService::Standard::Config

            attr_reader :id, :format, :title, :description

            step :validate_id, in: :id
            step :validate_format, in: :format
            step :validate_title, in: :title
            step :validate_description, in: :description

            def initialize(params:)
              @id = params[:id]
              @format = params[:format]
              @title = params[:title]
              @description = params[:description]
            end

            private

            def validate_id
              return error("ID is not a valid integer") unless Integer(id, exception: false)

              success
            end

            def validate_format
              return error("Only HTML format is supported") if format != "html"

              success
            end

            def validate_title
              return error("Title is `nil`") if title.nil?
              return error("Title is empty") if title.empty?

              success
            end

            def validate_description
              return error("Description is `nil`") if description.nil?

              success
            end
          end
        end
      end
    end
  end
end
