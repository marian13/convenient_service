# frozen_string_literal: true

module ConvenientService
  module Support
    class InfinitelyNestedHash
      include Support::Delegate

      delegate :[], :[]=, to: :hash

      attr_reader :hash

      def initialize
        @hash = create_hash
      end

      private

      def create_hash
        ::Hash.new.tap { |hash| hash.default_proc = proc { create_hash }}
      end
    end
  end
end
