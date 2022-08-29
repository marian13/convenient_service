# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Utils::Hash::Except.call({foo: :bar, baz: :qux}, keys: [:foo])
#
module ConvenientService
  module Utils
    module Hash
      class Except < Support::Command
        attr_reader :hash, :keys

        def initialize(hash, keys:)
          @hash = hash
          @keys = keys
        end

        ##
        # NOTE: Copied with minimal modifications from:
        # https://api.rubyonrails.org/classes/Hash.html#method-i-except
        #
        def call
          hash.slice(*hash.keys - keys)
        end
      end
    end
  end
end
