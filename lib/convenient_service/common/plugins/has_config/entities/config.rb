# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConfig
        module Entities
          class Config
            def initialize(hash = {})
              @hash = hash
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              to_h == other.to_h
            end

            def [](key)
              @hash[key]
            end

            def dup
              __duplicate__(self)
            end

            def to_h
              @hash
            end

            def to_read_default_write_config
              __duplicate__(self, config_class: Entities::ReadDefaultWriteConfig)
            end

            def to_read_only_config
              __duplicate__(self, config_class: Entities::ReadOnlyConfig)
            end

            protected

            def __duplicate__(object, options = {})
              case object
              when ::Array
                object.map { |value| __duplicate__(value, options) }
              when ::Hash
                object.transform_values { |value| __duplicate__(value, options) }
              when Entities::Config
                config_class = options.fetch(:config_class) { object.class }

                config_class.new(__duplicate__(object.to_h, options))
              else
                object.dup
              end
            end
          end
        end
      end
    end
  end
end
