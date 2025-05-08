# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Plugins
                      module HasMethodReaders
                        class Middleware < MethodChainMiddleware
                          intended_for :initiliaze, entity: :data

                          ##
                          # @return [void]
                          #
                          # @internal
                          #   NOTE: Rails has similar behaviour for `select`. For example `User.select("id AS custom_id").take.custom_id`.
                          #   - https://github.com/rails/rails/blob/v8.0.2/activemodel/lib/active_model/attribute_methods.rb#L553
                          #
                          #   NOTE: Hashie has similar behaviour.
                          #   - https://github.com/hashie/hashie/blob/master/lib/hashie/extensions/method_access.rb#L29
                          #
                          #   TODO: Specs.
                          #
                          def next(*args, **kwargs, &block)
                            chain.next(*args, **kwargs, &block)

                            kwargs[:value].each_pair do |attribute_name, attribute_value|
                              entity.define_singleton_method(attribute_name) { attribute_value }
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
      end
    end
  end
end
