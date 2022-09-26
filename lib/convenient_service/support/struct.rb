# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # Allows to `keyword_init` for Rubies lower than 2.5.
    #
    class Struct < ::Struct
      if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.0.0") && Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5.0")
        ##
        # NOTE: Copied with cosmetic modifications from:
        # https://github.com/marcandre/backports/blob/d422e696791317b3e8cf5af436b46a33ae276f70/lib/backports/2.5.0/struct/new.rb
        #
        class << self
          def new(*members, keyword_init: false, &block)
            klass = super(*members)

            if keyword_init
              members.shift unless members.first.is_a?(Symbol)

              arg_list = members.map { |m| "#{m}: nil" }.join(", ")

              setter = members.map { |m| "self.#{m} = #{m} " }.join("\n")

              <<~RUBY.tap { |code| klass.class_eval(code, __FILE__, __LINE__ + 1) }
                def initialize(#{arg_list})
                  #{setter}
                end
              RUBY
            end

            klass.class_eval(&block) if block

            klass
          end
        end
      end
    end
  end
end
