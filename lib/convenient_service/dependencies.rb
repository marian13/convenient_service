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
      # @api private
      #
      # @return [Boolean]
      # @see ConvenientService.Dependencies.require_has_j_send_result_params_validations_using_active_model_validations
      #
      def support_has_j_send_result_params_validations_using_active_model_validations?
        return false unless active_model.loaded?
        return false if ruby.version >= 3.0 && active_model.version < 6.0

        true
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      # @see https://github.com/ruby/logger/commit/74690b87b15244e19dd91cd06ae295251e1e5781
      #
      def support_logger_non_integer_levels?
        logger.version >= "1.3.0"
      end

      ##
      # @api public
      #
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_alias
        require_relative "alias"
      end

      ##
      # @api public
      #
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
      # @api public
      #
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
      # @api public
      #
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_can_utilize_finite_loop
        require_relative "common/plugins/can_utilize_finite_loop"
      end

      ##
      # @api public
      #
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
      # @api public
      #
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
        require_relative "service/configs/awesome_print_inspect"
        require_relative "service/configs/awesome_print_inspect/aliases"
      end

      ##
      # @api public
      #
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      # @see https://userdocs.convenientservice.org/troubleshooting/i18n_translate_wrong_number_of_arguments
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
      # @api public
      #
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
      # @api public
      #
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_rescues_result_unhandled_exceptions
        require_relative "service/plugins/rescues_result_unhandled_exceptions"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_wraps_result_in_db_transaction
        ##
        # - https://edgeguides.rubyonrails.org/active_record_basics.html
        # - https://api.rubyonrails.org/classes/ActiveRecord.html
        # - https://github.com/rails/rails/tree/main/activerecord
        #
        require "active_record"

        require_relative "service/plugins/wraps_result_in_db_transaction"
      end

      ##
      # @api private
      #
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

        ##
        #
        #
        require_relative "dependencies/extractions/ce"
      end

      ##
      # @api private
      #
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
      # @api public
      #
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
      # @api private
      #
      # Loads standard config examples.
      #
      # @param version [String]
      # @return [Boolean]
      #
      def require_standard_examples(version: "")
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

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/uri/rdoc/URI.html
        # - https://github.com/ruby/uri
        #
        require "uri"

        require_relative ::File.join("examples", "standard", version, "cowsay")
        require_relative ::File.join("examples", "standard", version, "date_time")
        require_relative ::File.join("examples", "standard", version, "factorial")
        require_relative ::File.join("examples", "standard", version, "gemfile")
        require_relative ::File.join("examples", "standard", version, "request_params")
      end

      ##
      # @api private
      #
      # Loads rails config examples.
      #
      # @param version [String]
      # @return [Boolean]
      #
      def require_rails_examples(version: "")
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

        require_relative ::File.join("examples", "rails", version, "gemfile")
      end

      ##
      # @api private
      #
      # Loads dry config examples.
      #
      # @param version [String]
      # @return [Boolean]
      #
      def require_dry_examples(version: "")
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

        require_relative ::File.join("examples", "dry", version, "gemfile")
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Support::Ruby]
      #
      def ruby
        Support::Ruby
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Support::RSpec]
      #
      def rspec
        Support::Gems::RSpec
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Support::Gems::ActiveModel]
      #
      def active_model
        Support::Gems::ActiveModel
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Support::Gems::Logger]
      #
      def logger
        Support::Gems::Logger
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Support::Gems::Paint]
      #
      def paint
        Support::Gems::Paint
      end
    end
  end
end
