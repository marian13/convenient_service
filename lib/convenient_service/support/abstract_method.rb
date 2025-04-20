# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "abstract_method/exceptions"

module ConvenientService
  module Support
    module AbstractMethod
      include Support::Concern

      class_methods do
        def abstract_method(*names)
          names.each do |name|
            define_method(name) do |*args, **kwargs, &block|
              ::ConvenientService.raise Exceptions::AbstractMethodNotOverridden.new(instance: self, method: name)
            end
          end
        end
      end
    end
  end
end
