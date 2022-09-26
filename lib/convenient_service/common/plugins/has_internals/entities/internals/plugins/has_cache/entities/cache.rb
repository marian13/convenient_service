# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            module Plugins
              module HasCache
                module Entities
                  ##
                  # TODO: Specs.
                  #
                  class Cache
                    attr_reader :hash

                    def initialize
                      @hash = {}
                    end

                    ##
                    # https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-exist-3F
                    #
                    def exist?(key)
                      hash.has_key?(key)
                    end

                    ##
                    # https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-read
                    #
                    def read(key)
                      hash[key]
                    end

                    ##
                    # NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:read).with(key).and_call_original` for both `cache[key]` and `cache.read(key)` in RSpec.
                    #
                    def [](key)
                      read(key)
                    end

                    ##
                    # https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-write
                    #
                    def write(key, value)
                      hash[key] = value
                    end

                    ##
                    # NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:write).with(key, value).and_call_original` for both `cache[key] = value` and `cache.write(key, value)` in RSpec.
                    #
                    def []=(key, value)
                      write(key, value)
                    end

                    ##
                    # https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-delete
                    #
                    def delete(key)
                      hash.delete(key)
                    end

                    ##
                    # https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-fetch
                    #
                    def fetch(key, &block)
                      return read(key) unless block

                      exist?(key) ? read(key) : write(key, block.call)
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
