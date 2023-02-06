# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class ReplaceFileContent
            include RailsService::Config

            attribute :path, :string
            attribute :content, :string

            validates :path, presence: true

            validate :content_not_nil

            step Services::AssertFileExists, in: :path
            step :result, in: :path

            def result
              ::File.write(path, content)

              success
            end

            private

            def content_not_nil
              errors.add(:content, "can't be nil") if content.nil?
            end
          end
        end
      end
    end
  end
end
