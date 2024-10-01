# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              ##
              # @internal
              #   NOTE: Plugin name is inspired by the `Responders` gem and `respond_to do |format|` from Rails.
              #   - https://github.com/heartcombo/responders
              #
              module HasStatusResponder
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Object] Can be any type.
                    #
                    # @internal
                    #   NOTE: Method name is inspired by `respond_to do |format|` from Rails.
                    #   - https://api.rubyonrails.org/classes/ActionController/MimeResponds.html#method-i-respond_to
                    #
                    def respond_to(&block)
                      collector = Entities::Collector.new(result: self, block: block)

                      collector.handle
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
