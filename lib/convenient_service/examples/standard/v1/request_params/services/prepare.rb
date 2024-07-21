# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Services
            class Prepare
              include ConvenientService::Standard::V1::Config

              attr_reader :request

              step Services::ExtractParamsFromPath, \
                in: [:request, {pattern: raw(/^\/rules\/(?<id>\d+)\.(?<format>\w+)$/)}],
                out: {params: :params_from_path}

              step Services::ExtractParamsFromBody, \
                in: :request,
                out: {params: :params_from_body}

              step Services::MergeParams, \
                in: [:params_from_path, :params_from_body],
                out: :params

              step Services::LogRequestParams, \
                in: [:request, :params, tag: raw("Uncasted")]

              step Services::FilterOutUnpermittedParams, \
                in: [:params, {permitted_keys: raw([:id, :format, :title, :description, :tags, :sources])}],
                out: :params

              step Services::ApplyDefaultParamValues, \
                in: [:params, defaults: raw({format: "json", tags: [], sources: []})],
                out: :params

              step Services::ValidateUncastedParams, \
                in: :params

              step Services::CastParams, \
                in: :params,
                out: [:original_params, {casted_params: :params}]

              step Services::LogRequestParams, \
                in: [:request, :params, tag: raw("Casted")]

              step Services::ValidateCastedParams, \
                in: [:original_params, {casted_params: :params}]

              step :result, \
                in: :params,
                out: :params

              def initialize(request:)
                @request = request
              end

              def result
                success(params: params)
              end
            end
          end
        end
      end
    end
  end
end
