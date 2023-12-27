# frozen_string_literal: true

module ConvenientService
  ##
  # Base class for all `ConvenientService` exceptions.
  #
  # @example Can be used as a catch-all solution.
  #
  #   begin
  #     any_service.result
  #   rescue ConvenientService::Exception => exception
  #     puts exception.message
  #   end
  #
  class Exception < ::StandardError
    class << self
      ##
      # Creates `ConvenientService` exception instance.
      # In contract to `StandardError.new`, may accept `kwargs`.
      # In such a case the descendant must implement `initialize_with_kwargs` to specify the logic of how to generate a `message`.
      # Without arguments behavior is also changed, it calls `initialize_without_arguments` instead of immediately setting `nil` as `message`.
      #
      # @note `initialize_with_kwargs` or `initialize_without_arguments` must call `initialize(message)`, otherwise exception instance won't be properly set up.
      #
      # @overload new
      #   Calls `initialize_without_arguments` under the hood to generate the exception message.
      #
      #   @api private
      #
      #   @return [ConvenientService::Exception]
      #
      #   @example Usage.
      #     module Exceptions
      #       class Foo < ::ConvenientService::Exception
      #         def initialize_without_arguments
      #           # message = ...
      #           initialize(message)
      #         end
      #       end
      #     end
      #
      #     ::ConvenientService.raise Foo.new
      #
      # @overload new(message)
      #   Calls `initialize(message)` under the hood to set the exception message.
      #
      #   @api private
      #
      #   @param message [String]
      #
      #   @return [ConvenientService::Exception]
      #
      #   @example Usage.
      #     module Exceptions
      #       class Foo < ::ConvenientService::Exception
      #       end
      #     end
      #
      #     ::ConvenientService.raise Foo.new("some message")
      #
      # @overload new(**kwargs)
      #   Calls `initialize_with_kwargs(**kwargs)` under the hood to generate the exception message.
      #
      #   @api private
      #
      #   @param kwargs [Hash{Symbol => Object}]
      #   @return [ConvenientService::Exception]
      #
      #   @example Usage.
      #     module Exceptions
      #       class Foo < ::ConvenientService::Exception
      #         def initialize_with_kwargs(**kwargs)
      #           # message = ...
      #           initialize(message)
      #         end
      #       end
      #     end
      #
      #     ::ConvenientService.raise Foo.new(foo: :bar, baz: :qux)
      #
      def new(message = nil, **kwargs)
        if message
          super(message)
        elsif kwargs.any?
          allocate.tap { |exception| exception.initialize_with_kwargs(**kwargs) }
        else
          allocate.tap(&:initialize_without_arguments)
        end
      end
    end

    ##
    # @internal
    #   NOTE: Two exceptions are equal when their classes, messages, and backtraces are equal.
    #   - https://blog.arkency.com/2015/01/ruby-exceptions-equality
    #
    #   TODO: Compare skipping backtraces? Why?
    #
    # def ==(other)
    #   # ...
    # end
    ##
  end
end
