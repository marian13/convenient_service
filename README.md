<!-- header:start -->
<!-- TODO: Remove html to display in YARD with commonmark -->
<h1 align="center">
  Convenient Service
</h1>
<!-- header:end -->

<!-- badges:start -->
[![Gem Version](https://badge.fury.io/rb/convenient_service.svg)](https://rubygems.org/gems/convenient_service) [![GitHub Actions CI](https://github.com/marian13/convenient_service/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/marian13/convenient_service/actions/workflows/ci.yml) [![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard) [![Coverage Status](https://coveralls.io/repos/github/marian13/convenient_service/badge.svg)](https://coveralls.io/github/marian13/convenient_service?branch=main) [![inline docs](http://inch-ci.org/github/marian13/convenient_service.svg?branch=main)](http://inch-ci.org/github/marian13/convenient_service)
[![Convenient Service on stackoverflow](https://img.shields.io/badge/stackoverflow-community-orange.svg?logo=stackoverflow)](https://stackoverflow.com/tags/convenient-service)
[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/user?u=31435716&fan_landing=true)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges:end -->

<!-- logo:start -->
<!-- TODO: Remove html to display in YARD with commonmark -->
<p align="center">
  <img src="https://raw.githubusercontent.com/marian13/convenient_service/main/logo.png" width="300">
</p>
<!-- logo:end -->

<!-- general_description:start -->
Yet another approach to revisit the service object pattern, but this time focusing on the unique, opinionated features.

\* Logo is downloaded from [CuteWallpaper.org](https://cutewallpaper.org/24/cartoon-diamond-png/2703010921.html). It will be replaced later.
<!-- general_description:end -->

<!-- warning:start -->
## WARNING ❗❗❗

This library is under heavy development. Public API may be subject to change. The first major release is still to come. Use the current version at your own risk. Ruby 2.7+. Thanks.
<!-- features:end -->
<!-- warning:end -->

<!-- usage:start -->
## Usage

<details open>
  <summary>
    <!-- NOTE: style does NOT work in GitHub -->
    <h3 style="display: inline-block; margin-top: 0; margin-bottom: 0;">
      Standard
    </h3>
  </summary>

  ```ruby
  # frozen_string_literal: true

  require "convenient_service"
  ```

  ```ruby
  # frozen_string_literal: true

  class ApplicationService
    module Config
      def self.included(service_class)
        service_class.include ConvenientService::Standard::Config
      end
    end
  end
  ```

  ```ruby
  # frozen_string_literal: true

  class AssertFileExists
    include ApplicationService::Config

    attr_accessor :path

    def initialize(path:)
      @path = path
    end

    def result
      return failure(data: {path: "Path is `nil`"}) if path.nil?
      return failure(data: {path: "Path is empty"}) if path.empty?

      return error(message: "File with path `#{path}` does NOT exist") unless ::File.exist?(path)

      success
    end
  end
  ```

  ```ruby
  result = AssertFileExists.result(path: "Gemfile")
  ```

  ```ruby
  # frozen_string_literal: true

  class AssertFileNotEmpty
    include ApplicationService::Config

    attr_accessor :path

    def initialize(path:)
      @path = path
    end

    def result
      return failure(data: {path: "Path is `nil`"}) if path.nil?
      return failure(data: {path: "Path is empty"}) if path.empty?

      return error(message: "File with path `#{path}` is empty") if ::File.zero?(path)

      success
    end
  end
  ```

  ```ruby
  result = AssertFileNotEmpty.result(path: "Gemfile")
  ```

  ```ruby
  # frozen_string_literal: true

  class ReadFileContent
    include ApplicationService::Config

    attr_reader :path

    step :validate_path
    step AssertFileExists, in: :path
    step AssertFileNotEmpty, in: :path
    step :result, in: :path, out: :content

    def initialize(path:)
      @path = path
    end

    def result
      success(data: {content: ::File.read(path)})
    end

    private

    def validate_path
      return failure(data: {path: "Path is `nil`"}) if path.nil?
      return failure(data: {path: "Path is empty"}) if path.empty?

      success
    end
  end
  ```

  ```ruby
  result = ReadFileContent.result(path: "Gemfile")

  if result.success?
    puts result.data[:content]
  else
    puts result.message
  end
  ```
</details>

<details>
  <summary>
    <!-- NOTE: style does NOT work in GitHub -->
    <h3 style="display: inline-block; margin-top: 0; margin-bottom: 0;">
      Rails
    </h3>
  </summary>

  ```ruby
  # frozen_string_literal: true

  ##
  # NOTE: Minimal `active_model` version - `5.2.0`.
  #
  require "active_model"

  require "convenient_service"

  ConvenientService.require_assigns_attributes_in_constructor_using_active_model_attribute_assignment
  ConvenientService.require_has_attributes_using_active_model_attributes
  ConvenientService.require_has_result_params_validations_using_active_model_validations
  ```

  ```ruby
  # frozen_string_literal: true

  class RailsService
    module Config
      def self.included(service_class)
        service_class.class_exec do
          include ConvenientService::Standard::Config

          ##
          # NOTE: `AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment` plugin.
          #
          concerns do
            use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
          end

          middlewares :initialize do
            use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
          end

          ##
          # NOTE: `HasAttributes::UsingActiveModelAttributes` plugin.
          #
          concerns do
            use ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern
          end

          ##
          # NOTE: `HasResultParamsValidations::UsingActiveModelValidations` plugin.
          #
          concerns do
            use ConvenientService::Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Concern
          end

          middlewares :result do
            use ConvenientService::Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Middleware
          end
        end
      end
    end
  end
  ```

  ```ruby
  # frozen_string_literal: true

  class AssertFileExists
    include RailsService::Config

    attribute :path, :string

    validates :path, presence: true

    def result
      return error(message: "File with path `#{path}` does NOT exist") unless ::File.exist?(path)

      success
    end
  end
  ```

  ```ruby
  result = AssertFileExists.result(path: "Gemfile")
  ```

  ```ruby
  # frozen_string_literal: true

  class AssertFileNotEmpty
    include RailsService::Config

    attribute :path, :string

    validates :path, presence: true

    def result
      return error(message: "File with path `#{path}` is empty") if ::File.zero?(path)

      success
    end
  end
  ```

  ```ruby
  result = AssertFileNotEmpty.result(path: "Gemfile")
  ```

  ```ruby
  # frozen_string_literal: true

  class ReadFileContent
    include RailsService::Config

    attribute :path, :string

    validates :path, presence: true

    step AssertFileExists, in: :path
    step AssertFileNotEmpty, in: :path
    step :result, in: :path, out: :content

    def result
      success(data: {content: ::File.read(path)})
    end
  end
  ```

  ```ruby
  result = ReadFileContent.result(path: "Gemfile")

  if result.success?
    puts result.data[:content]
  else
    puts result.message
  end
  ```
</details>

<details>
  <summary>
    <!-- NOTE: style does NOT work in GitHub -->
    <h3 style="display: inline-block; margin-top: 0; margin-bottom: 0;">
      Dry
    </h3>
  </summary>

  ```ruby
  # frozen_string_literal: true

  ##
  # NOTE: Minimal `dry-initializer` version - `3.0.0`.
  #
  require "dry-initializer"

  ##
  # NOTE: Minimal `dry-validation` version - `1.5.0`.
  #
  require "dry-validation"

  require "convenient_service"

  ConvenientService.require_assigns_attributes_in_constructor_using_dry_initializer
  ConvenientService.require_has_result_params_validations_using_dry_validation
  ```

  ```ruby
  class DryService
    module Config
      def self.included(service_class)
        service_class.class_exec do
          include ConvenientService::Standard::Config

          ##
          # NOTE: `AssignsAttributesInConstructor::UsingDryInitializer` plugin.
          #
          concerns do
            use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern
          end

          ##
          # NOTE: `HasResultParamsValidations::UsingDryValidation` plugin.
          #
          concerns do
            use ConvenientService::Plugins::Service::HasResultParamsValidations::UsingDryValidation::Concern
          end

          middlewares :result do
            use ConvenientService::Plugins::Service::HasResultParamsValidations::UsingDryValidation::Middleware
          end
        end
      end
    end
  end
  ```

  ```ruby
  # frozen_string_literal: true

  class AssertFileExists
    include DryService::Config

    option :path

    contract do
      schema do
        required(:path).value(:string)
      end
    end

    def result
      return error(message: "File with path `#{path}` does NOT exist") unless ::File.exist?(path)

      success
    end
  end
  ```

  ```ruby
  result = AssertFileExists.result(path: "Gemfile")
  ```

  ```ruby
  # frozen_string_literal: true

  class AssertFileNotEmpty
    include DryService::Config

    option :path

    contract do
      schema do
        required(:path).value(:string)
      end
    end

    def result
      return error(message: "File with path `#{path}` is empty") if ::File.zero?(path)

      success
    end
  end
  ```

  ```ruby
  result = AssertFileNotEmpty.result(path: "Gemfile")
  ```

  ```ruby
  # frozen_string_literal: true

  class ReadFileContent
    include DryService::Config

    option :path

    contract do
      schema do
        required(:path).value(:string)
      end
    end

    step AssertFileExists, in: :path
    step AssertFileNotEmpty, in: :path
    step :result, in: :path, out: :content

    def result
      success(data: {content: ::File.read(path)})
    end
  end
  ```

  ```ruby
  result = ReadFileContent.result(path: "Gemfile")

  if result.success?
    puts result.data[:content]
  else
    puts result.message
  end
  ```
</details>
<!-- usage:end -->

---

<!-- author:start -->
Copyright (c) 2022 [Marian Kostyk](http://mariankostyk.com).
<!-- author:end -->
