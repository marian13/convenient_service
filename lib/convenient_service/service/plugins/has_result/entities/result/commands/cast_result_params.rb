# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Commands
              class CastResultParams < Support::Command
                attr_reader :params

                def initialize(params:)
                  @params = params
                end

                def call
                  Structs::ResultParams.new(
                    service: params[:service],
                    status: Entities::Status.cast!(params[:status]),
                    data: Entities::Data.cast!(params[:data]),
                    message: Entities::Message.cast!(params[:message]),
                    code: Entities::Code.cast!(params[:code])
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
