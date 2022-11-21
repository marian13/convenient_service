# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Standard::Gemfile::Services::FormatDate.result(date_string: '5th Mar 2021 04:05:06+03:30', print_out: true)
# result = ConvenientService::Examples::Standard::Gemfile::Services::FormatDate.result(date_string: '5th Mar 2021 04:05:06+03:30', print_out: false)
#
module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class FormatDate
            include ConvenientService::Standard::Config

            attr_reader :date_string

            def initialize(date_string:)
              @date_string = date_string
            end

            def result
              return failure(data: {date_string: "Date string can NOT be nil"}) if date_string.nil?
              return failure(data: {date_string: "Date string can NOT be empty"}) if date_string.empty?

              success(data: {formatted_date: format_date})
            end

            private

            def format_date
              parse_date.strftime("%d-%m-%Y")
            end

            def parse_date
              @parse_date = DateTime.parse(date_string)
            end
          end
        end
      end
    end
  end
end
