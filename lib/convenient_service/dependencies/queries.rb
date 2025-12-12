# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "queries/version"
require_relative "queries/ruby"
require_relative "queries/gems"

module ConvenientService
  module Dependencies
    ##
    # @internal
    #   IMPORTANT: Ensure this module NEVER uses any stdlibs that are not loaded by `rubygems` and external gems, since it is utilized in `gemspec`.
    #
    module Queries
      ##
      # @internal
      #   NOTE: `module_function` does NOT define methods in a way to make them available by `extend` in other modules. That is why `extend self` is used.
      #
      extend self

      ##
      # @api private
      #
      # @return [Boolean]
      #
      # @see https://github.com/deivid-rodriguez/byebug/issues/289
      #
      # @internal
      #   NOTE: Ruby 3.5 does not ship with the `readline` by default. That is why `byebug` throws the following error:
      #     Sorry, you can't use byebug without Readline. To solve this, you need to
      #     rebuild Ruby with Readline support. If using Ubuntu, try `sudo apt-get
      #     install libreadline-dev` and then reinstall your Ruby.
      #
      #     LoadError:
      #       cannot load such file -- readline
      #
      #   The bigger problem is that the `readline` (`libreadline-dev`) must be available before building Ruby.
      #   In other words, the full Docker image source should be copied, extended, and built locally.
      #
      def support_byebug?
        ruby.mri? && ruby.version < 3.5
      end

      ##
      # @api private
      #
      # @return [Boolean]
      # @see ConvenientService.Dependencies.require_has_j_send_result_params_validations_using_active_model_validations_plugin
      #
      def support_has_j_send_result_params_validations_using_active_model_validations_plugin?
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
      # @api private
      #
      # @return [Boolean]
      #
      def require_alias
        ::Object.const_set(:CS, ::ConvenientService)
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_assigns_attributes_in_constructor_using_active_model_attribute_assignment_plugin
        ##
        # - https://edgeguides.rubyonrails.org/active_model_basics.html
        # - https://api.rubyonrails.org/classes/ActiveModel.html
        # - https://github.com/rails/rails/tree/main/activemodel
        #
        require "active_model"

        require "convenient_service/common/plugins/assigns_attributes_in_constructor/using_active_model_attribute_assignment"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_assigns_attributes_in_constructor_using_dry_initializer_plugin
        ##
        # - https://dry-rb.org/gems/dry-initializer/main
        # - https://github.com/dry-rb/dry-initializer
        #
        require "dry-initializer"

        require "convenient_service/common/plugins/assigns_attributes_in_constructor/using_dry_initializer"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_has_attributes_using_active_model_attributes_plugin
        ##
        # - https://edgeguides.rubyonrails.org/active_model_basics.html
        # - https://api.rubyonrails.org/classes/ActiveModel.html
        # - https://github.com/rails/rails/tree/main/activemodel
        #
        require "active_model"

        require "convenient_service/common/plugins/has_attributes/using_active_model_attributes"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_amazing_print_inspect_standard_config_option
        ##
        # - https://github.com/amazing-print/amazing_print
        #
        require "amazing_print"

        require "convenient_service/service/plugins/has_amazing_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_amazing_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/data/plugins/has_amazing_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/message/plugins/has_amazing_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/status/plugins/has_amazing_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/code/plugins/has_amazing_print_inspect"
        require "convenient_service/service/plugins/can_have_steps/entities/step/plugins/has_amazing_print_inspect"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      # Loads a config that patches services to use Awesome Print to generate colored `inspect` strings.
      # Useful for debugging.
      # Works as expected for `byebug` and `pry`.
      #
      # Has issues with escaping colors for `binding.break` and `irb`.
      # There is a workaround in the examples, but its possible negative outcome has not been investigated yet. Use it at your own risk.
      #
      # @example `:awesome_print_inspect` output for `byebug` or `pry`.
      #   class Service
      #     include ::ConvenientService::Standard::Config.with(:awesome_print_inspect)
      #
      #     def result
      #       success(foo: :bar)
      #     end
      #   end
      #
      #   Service.result
      #   # =>
      #   {
      #     :ConvenientService => {
      #            :entity => "Result",
      #           :service => "Service",
      #            :status => :success,
      #         :data_keys => [
      #             [0] :foo
      #         ]
      #     }
      #   }
      #
      # @example `:awesome_print_inspect` output for `binding.break` or `irb`.
      #
      #   class Service
      #     include ::ConvenientService::Standard::Config.with(:awesome_print_inspect)
      #
      #     def result
      #       success(foo: :bar)
      #     end
      #   end
      #
      #   Service.result
      #   # =>
      #   {
      #     :ConvenientService^[[0;37m => ^[[0m{
      #            :entity^[[0;37m => ^[[0m^[[0;33m"Result"^[[0m,
      #           :service^[[0;37m => ^[[0m^[[0;33m"Service"^[[0m,
      #            :status^[[0;37m => ^[[0m^[[0;36m:success^[[0m,
      #         :data_keys^[[0;37m => ^[[0m[
      #             ^[[1;37m[0] ^[[0m^[[0;36m:foo^[[0m
      #         ]
      #       }
      #   }
      #
      # @example `:awesome_print_inspect` output for `binding.break` or `irb` with `Reline` hack.
      #
      #   class Service
      #     include ::ConvenientService::Standard::Config.with(:awesome_print_inspect)
      #
      #     def result
      #       success(foo: :bar)
      #     end
      #   end
      #
      #   class Reline::Unicode
      #     def self.escape_for_print(str)
      #       str
      #     end
      #   end
      #
      #   Service.result
      #   # =>
      #   {
      #     :ConvenientService => {
      #            :entity => "Result",
      #           :service => "Service",
      #            :status => :success,
      #         :data_keys => [
      #             [0] :foo
      #         ]
      #     }
      #   }
      #
      # @see https://github.com/awesome-print/awesome_print
      # @see https://github.com/ruby/irb/blob/v1.13.1/lib/irb/inspector.rb#L113
      # @see https://github.com/ruby/irb/blob/v1.13.1/lib/irb/color.rb#L150
      # @see https://github.com/ruby/reline/blob/v0.5.8/lib/reline/unicode.rb#L30
      #
      def require_awesome_print_inspect_standard_config_option
        ##
        # - https://github.com/awesome-print/awesome_print
        #
        require "awesome_print"

        require "convenient_service/service/plugins/has_awesome_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_awesome_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/data/plugins/has_awesome_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/message/plugins/has_awesome_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/status/plugins/has_awesome_print_inspect"
        require "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/code/plugins/has_awesome_print_inspect"
        require "convenient_service/service/plugins/can_have_steps/entities/step/plugins/has_awesome_print_inspect"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_dry_initializer_standard_config_option
        require_assigns_attributes_in_constructor_using_dry_initializer_plugin
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_active_model_validations_standard_config_option
        require_has_j_send_result_params_validations_using_active_model_validations_plugin
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_memo_wise_standard_config_option
        require_has_memoization_using_memo_wise_plugin
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      # @see https://userdocs.convenientservice.org/troubleshooting/i18n_translate_wrong_number_of_arguments
      #
      def require_has_j_send_result_params_validations_using_active_model_validations_plugin
        ##
        # - https://edgeguides.rubyonrails.org/active_model_basics.html
        # - https://api.rubyonrails.org/classes/ActiveModel.html
        # - https://github.com/rails/rails/tree/main/activemodel
        #
        require "active_model"

        require "convenient_service/service/plugins/has_j_send_result_params_validations/using_active_model_validations"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_has_j_send_result_params_validations_using_dry_validation_plugin
        ##
        # - https://dry-rb.org/gems/dry-validation/main/
        # - https://github.com/dry-rb/dry-validation
        #
        require "dry-validation"

        require "convenient_service/service/plugins/has_j_send_result_params_validations/using_dry_validation"
      end

      def require_has_memoization_using_memo_wise_plugin
        ##
        # - https://github.com/panorama-ed/memo_wise
        #
        require "memo_wise"

        require "convenient_service/common/plugins/has_memoization/using_memo_wise"
      end

      ##
      # @api private
      #
      # @return [Boolean]
      #
      def require_wraps_result_in_db_transaction_using_active_record_base_transaction_plugin
        ##
        # - https://edgeguides.rubyonrails.org/active_record_basics.html
        # - https://api.rubyonrails.org/classes/ActiveRecord.html
        # - https://github.com/rails/rails/tree/main/activerecord
        #
        require "active_record"

        require "convenient_service/service/plugins/wraps_result_in_db_transaction/using_active_record_base_transaction"
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
      def require_development_tools(amazing_print: false, awesome_print: true)
        ##
        # - https://github.com/awesome-print/awesome_print
        #
        require "awesome_print" if awesome_print

        ##
        # - https://github.com/amazing-print/amazing_print
        #
        require "amazing_print" if amazing_print

        ##
        # - https://github.com/gsamokovarov/break
        #
        require "break"

        ##
        # - https://github.com/deivid-rodriguez/byebug
        #
        require "byebug" if support_byebug?

        ##
        # - https://github.com/ruby/debug
        #
        require "debug" if ruby.mri?

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
        # - https://github.com/ruby/pp
        #
        require "pp"

        ##
        # - https://github.com/rouge-ruby/rouge
        #
        require "rouge"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/tempfile/rdoc/Tempfile.html
        # - https://github.com/ruby/tempfile
        #
        require "tempfile"

        require "convenient_service/debug/convenient_service"

        require "convenient_service/debug/b" if support_byebug?
        require "convenient_service/debug/byebug_syntax_highlighting" if support_byebug?
        require "convenient_service/debug/bb" if ruby.mri?
        require "convenient_service/debug/ce"
        require "convenient_service/debug/ds"

        require "convenient_service/debug/thread_backtraces"
        require "convenient_service/debug/break"
        require "convenient_service/debug/timeout"
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
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/strscan/rdoc/StringScanner.html
        # - https://github.com/ruby/strscan
        #
        require "strscan"

        ##
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/tempfile/rdoc/Tempfile.html
        # - https://github.com/ruby/tempfile
        #
        require "tempfile"
      end

      ##
      # @api private
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

        require "convenient_service/rspec"
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

        require ::File.join("convenient_service", "examples", "standard", version, "cowsay")
        require ::File.join("convenient_service", "examples", "standard", version, "date_time")
        require ::File.join("convenient_service", "examples", "standard", version, "factorial")
        require ::File.join("convenient_service", "examples", "standard", version, "gemfile")
        require ::File.join("convenient_service", "examples", "standard", version, "request_params")
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

        require ::File.join("convenient_service", "examples", "rails", version, "gemfile")
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

        require ::File.join("convenient_service", "examples", "dry", version, "gemfile")
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Dependencies::Queries::Ruby]
      #
      def ruby
        Ruby
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Dependencies::Queries::RSpec]
      #
      def rspec
        Gems::RSpec
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Dependencies::Queries::Gems::ActiveModel]
      #
      def active_model
        Gems::ActiveModel
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Dependencies::Queries::Gems::Logger]
      #
      def logger
        Gems::Logger
      end

      ##
      # @api private
      #
      # @return [ConvenientService::Dependencies::Queries::Gems::Paint]
      #
      def paint
        Gems::Paint
      end

      ##
      # @api private
      #
      # @return [String]
      #
      # @internal
      #   IMPORTANT: `appraisal_name` MUST NOT be used inside the lib folder.
      #
      #   NOTE: Previous appraisal name detection logic was relying on a a fact that `appraisals` gem sets `BUNDLE_GEMFILE` env variable.
      #   - https://github.com/thoughtbot/appraisal/blob/v2.4.1/lib/appraisal/command.rb#L36
      #
      #   When `BUNDLE_GEMFILE` was an empty string, then `APPRAISAL_NAME` was resolved to an empty string as well. For example:
      #     ::ENV["BUNDLE_GEMFILE"]
      #       .to_s
      #       .then(&::File.method(:basename))
      #       .then { |name| name.end_with?(".gemfile") ? name.delete_suffix(".gemfile") : "" }
      #
      #   Now, appraisal name detection logic is based on `ENV["APPRAISAL_NAME"]` passed for Taskfile.
      #
      #
      # @internal
      #   TODO: Add direct specs.
      #
      def appraisal_name
        ::ENV["APPRAISAL_NAME"].to_s
      end

      ##
      # @api private
      #
      # @return [String]
      #
      # @internal
      #   TODO: Add direct specs.
      #
      def appraisal_name_for_coverage
        appraisal_name.empty? ? "without_appraisal" : appraisal_name
      end
    end
  end
end
