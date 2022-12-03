# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class Prepare
            include ConvenientService::Standard::Config

            attr_reader :request, :role

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
              in: [:params, {permitted_keys: raw([:id, :title, :description, :tags])}],
              out: reassign(:params)

            step Services::ApplyDefaultParamValues, \
              in: :params,
              out: reassign(:params)

            step Services::ValidateUncastedParams, \
              in: :params

            step Services::CastParams, \
              in: :params,
              out: reassign(:params)

            step Services::LogRequestParams, \
              in: [:request, :params, tag: raw("Casted")]

            step Services::ValidateCastedParams, \
              in: :params

            step Services::SanitizeParams, \
              in: :params,
              out: reassign(:params)

            step Services::RemoveUnauthorizedParams, \
              in: [:params, :role],
              out: reassign(:params)

            step Services::ApplyPolicyScopesToParams, \
              in: [:params, :role],
              out: reassign(:params)

            step Services::TriggerParamsHooks, \
              in: :params

            step Services::AuditParams, \
              in: :params

            step :result, \
              in: :params,
              out: reassign(:params)

            def initialize(request:, role: Constants::Roles::GUEST)
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
