# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class DateTime
          module Services
            class SafeParse
              include ConvenientService::Standard::V1::Config

              attr_reader :string, :format

              def initialize(string:, format:)
                @string = string
                @format = format
              end

              def result
                success(date_time: ::DateTime.strptime(string, format))
              rescue ::Date::Error => exception
                failure(
                  data: {exception: exception},
                  message: "Failed to parse `DateTime` object from `#{string}` with `#{format}`"
                )
              end
            end
          end
        end
      end
    end
  end
end
