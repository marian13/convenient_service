# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: Waits for `should-matchers` full support.
#
# TODO: Contribute. Remove "shoulda-matchers" dependency on ActiveRecord.
# - https://github.com/thoughtbot/shoulda-matchers/blob/v5.0.0/lib/shoulda/matchers/active_model/validate_presence_of_matcher.rb#L360
# - https://github.com/thoughtbot/shoulda-matchers/blob/v5.0.0/lib/shoulda/matchers/rails_shim.rb#L61
# - https://github.com/thoughtbot/shoulda-matchers/blob/v5.0.0/lib/shoulda/matchers/rails_shim.rb#L51
#
#   module Shoulda
#     module Matchers
#       ##
#       #
#       #
#       module RailsShim
#         class << self
#           def serialized_attributes_for(model)
#             attribute_types_for(model).
#               inject({}) do |hash, (attribute_name, attribute_type)|
#                 if (defined? ::ActiveRecord::Type::Serialized) && attribute_type.is_a?(::ActiveRecord::Type::Serialized)
#                   hash.merge(attribute_name => attribute_type.coder)
#                 else
#                   hash
#                 end
#               end
#           rescue NotImplementedError
#             {}
#           end
#         end
#       end
#     end
#   end
#
# Configures `shoulda-matchers`.
# https://github.com/thoughtbot/shoulda-matchers#rspec
#
#   Shoulda::Matchers.configure do |config|
#     config.integrate do |with|
#       with.test_framework :rspec
#
#       with.library :active_model
#     end
#   end
