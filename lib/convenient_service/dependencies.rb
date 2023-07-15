# frozen_string_literal: true

require_relative "dependencies/built_in"
require_relative "dependencies/extractions"

##
# `ConvenientService::Dependencies` can dynamically require plugins/extensions that have external dependencies.
#
# @internal
#   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
#
module ConvenientService
  module Dependencies
    class << self
      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_alias
        require_relative "alias"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_assigns_attributes_in_constructor_using_active_model_attribute_assignment
        ##
        # - https://edgeguides.rubyonrails.org/active_model_basics.html
        # - https://api.rubyonrails.org/classes/ActiveModel.html
        # - https://github.com/rails/rails/tree/main/activemodel
        #
        require "active_model"

        require_relative "common/plugins/assigns_attributes_in_constructor/using_active_model_attribute_assignment"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_assigns_attributes_in_constructor_using_dry_initializer
        ##
        # - https://dry-rb.org/gems/dry-initializer/main
        # - https://github.com/dry-rb/dry-initializer
        #
        require "dry-initializer"

        require_relative "common/plugins/assigns_attributes_in_constructor/using_dry_initializer"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_can_utilize_finite_loop
        require_relative "common/plugins/can_utilize_finite_loop"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_has_attributes_using_active_model_attributes
        ##
        # - https://edgeguides.rubyonrails.org/active_model_basics.html
        # - https://api.rubyonrails.org/classes/ActiveModel.html
        # - https://github.com/rails/rails/tree/main/activemodel
        #
        require "active_model"

        require_relative "common/plugins/has_attributes/using_active_model_attributes"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_awesome_print_inspect
        ##
        # - https://github.com/awesome-print/awesome_print
        #
        require "awesome_print"

        require_relative "service/plugins/has_awesome_print_inspect"
        require_relative "service/plugins/has_j_send_result/entities/result/plugins/has_awesome_print_inspect"
        require_relative "service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/data/plugins/has_awesome_print_inspect"
        require_relative "service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/message/plugins/has_awesome_print_inspect"
        require_relative "service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/status/plugins/has_awesome_print_inspect"
        require_relative "service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/code/plugins/has_awesome_print_inspect"
        require_relative "service/plugins/can_have_steps/entities/step/plugins/has_awesome_print_inspect"
        require_relative "configs/awesome_print_inspect"
        require_relative "configs/awesome_print_inspect/aliases"
      end

      ##
      # @return [Boolean]
      # @api private
      #
      def support_has_j_send_result_params_validations_using_active_model_validations?
        return false unless active_model.loaded?
        return false if ruby.version >= 3.0 && active_model.version < 6.0

        true
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      # @see https://marian13.github.io/convenient_service_docs/troubleshooting/i18n_translate_wrong_number_of_arguments
      #
      def require_has_j_send_result_params_validations_using_active_model_validations
        ##
        # - https://edgeguides.rubyonrails.org/active_model_basics.html
        # - https://api.rubyonrails.org/classes/ActiveModel.html
        # - https://github.com/rails/rails/tree/main/activemodel
        #
        require "active_model"

        require_relative "service/plugins/has_j_send_result_params_validations/using_active_model_validations"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_has_j_send_result_params_validations_using_dry_validation
        ##
        # - https://dry-rb.org/gems/dry-validation/main/
        # - https://github.com/dry-rb/dry-validation
        #
        require "dry-validation"

        require_relative "service/plugins/has_j_send_result_params_validations/using_dry_validation"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_rescues_result_unhandled_exceptions
        require_relative "service/plugins/rescues_result_unhandled_exceptions"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_cleans_exception_backtrace
        require_relative "dependencies/extractions/active_support_backtrace_cleaner"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from `irb`, `pry`, `spec_helper.rb`, etc.
      #
      # @internal
      #   NOTE: `byebug` has C extensions, that is why it is NOT supported in JRuby.
      #   - https://github.com/deivid-rodriguez/byebug/tree/master/ext/byebug
      #   - https://github.com/deivid-rodriguez/byebug/issues/179#issuecomment-152727003
      #
      def require_development_tools
        ##
        # - https://github.com/awesome-print/awesome_print
        #
        require "awesome_print"

        ##
        # - https://github.com/gsamokovarov/break
        #
        require "break"

        ##
        # - https://github.com/deivid-rodriguez/byebug
        #
        require "byebug" unless ruby.jruby?

        ##
        # - https://github.com/ruby/debug
        #
        require "debug" unless ruby.jruby?

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/ostruct/rdoc/OpenStruct.html
        # - https://github.com/ruby/ostruct
        #
        require "ostruct"

        ##
        # - https://github.com/janlelis/paint
        #
        require "paint"

        ##
        # - https://github.com/rouge-ruby/rouge
        #
        require "rouge"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/tempfile/rdoc/Tempfile.html
        # - https://github.com/ruby/tempfile
        #
        require "tempfile"

        ##
        # - https://gist.github.com/marian13/5dade20a431d7254db30e543167058ce
        #
        require_relative "dependencies/extractions/byebug_syntax_highlighting" unless ruby.jruby?

        require_relative "dependencies/extractions/b" unless ruby.jruby?
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from `spec_helper.rb`.
      #
      def require_test_tools
        ##
        # - https://github.com/faker-ruby/faker
        #
        require "faker"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/ostruct/rdoc/OpenStruct.html
        # - https://github.com/ruby/ostruct
        #
        require "ostruct"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/tempfile/rdoc/Tempfile.html
        # - https://github.com/ruby/tempfile
        #
        require "tempfile"
      end

      ##
      # Loads RSpec extensions like `be_success` matcher, `stub_service` helper, etc.
      #
      # @return [Boolean]
      # @note Expected to be called from `spec_helper.rb`.
      #
      def require_rspec_extentions
        require "rspec/expectations"
        require "rspec/matchers"
        require "rspec/mocks"

        require_relative "rspec"
      end

      ##
      # Loads standard config examples.
      #
      # @return [Boolean]
      # @api private
      #
      def require_standard_examples
        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/date/rdoc/Date.html
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/date/rdoc/DateTime.html
        # - https://github.com/ruby/date
        #
        require "date"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/json/rdoc/JSON.html
        # - https://github.com/flori/json
        #
        require "json"

        ##
        # - https://github.com/jfelchner/ruby-progressbar
        #
        require "progressbar"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/webrick/rdoc/WEBrick.html
        # - https://github.com/ruby/webrick
        #
        require "webrick"

        require_relative "examples/standard/cowsay"
        require_relative "examples/standard/date_time"
        require_relative "examples/standard/factorial"
        require_relative "examples/standard/gemfile"
        require_relative "examples/standard/request_params"
      end

      ##
      # Loads rails config examples.
      #
      # @return [Boolean]
      # @api private
      #
      def require_rails_examples
        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/json/rdoc/JSON.html
        # - https://github.com/flori/json
        #
        require "json"

        ##
        # - https://github.com/jfelchner/ruby-progressbar
        #
        require "progressbar"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/webrick/rdoc/WEBrick.html
        # - https://github.com/ruby/webrick
        #
        require "webrick"

        require_relative "examples/rails/gemfile"
      end

      ##
      # Loads dry config examples.
      #
      # @return [Boolean]
      # @api private
      #
      def require_dry_examples
        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/json/rdoc/JSON.html
        # - https://github.com/flori/json
        #
        require "json"

        ##
        # - https://github.com/jfelchner/ruby-progressbar
        #
        require "progressbar"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/webrick/rdoc/WEBrick.html
        # - https://github.com/ruby/webrick
        #
        require "webrick"

        require_relative "examples/dry/gemfile"
      end

      ##
      # @return [ConvenientService::Support::Ruby]
      # @api private
      #
      def ruby
        Support::Ruby
      end

      ##
      # @return [ConvenientService::Support::RSpec]
      # @api private
      #
      def rspec
        Support::Gems::RSpec
      end

      ##
      # @return [ConvenientService::Support::Gems::ActiveModel]
      # @api private
      #
      def active_model
        Support::Gems::ActiveModel
      end
    end
  end
end
