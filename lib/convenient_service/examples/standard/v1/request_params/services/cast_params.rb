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
            class CastParams
              include ConvenientService::Standard::V1::Config

              attr_reader :params

              def initialize(params:)
                @params = params
              end

              def result
                success(original_params: params, casted_params: casted_params)
              end

              private

              def casted_params
                {
                  id: Entities::ID.cast(params[:id]),
                  format: Entities::Format.cast(params[:format]),
                  title: Entities::Title.cast(params[:title]),
                  description: Entities::Description.cast(params[:description]),
                  tags: Utils::Array.wrap(params[:tags]).map { |tag| Entities::Tag.cast(tag) },
                  sources: Utils::Array.wrap(params[:sources]).map { |source| Entities::Source.cast(source) }
                }
              end
            end
          end
        end
      end
    end
  end
end
