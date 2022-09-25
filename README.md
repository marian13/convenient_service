<!-- header:start -->
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
<p align="center">
  <img src="https://raw.githubusercontent.com/marian13/convenient_service/main/logo.png" width="300">
</p>
<!-- logo:end -->

<!-- general_description:start -->
Yet another approach to revisit the service object pattern, but this time focusing on the unique, opinionated features.

\* Logo is downloaded from [CuteWallpaper.org](https://cutewallpaper.org/24/cartoon-diamond-png/2703010921.html). It will be replaced later.
<!-- general_description:end -->

<!-- warning:start -->
### WARNING ❗❗❗

This library is under heavy development. Public API may be subject to change. The first major release is still to come. Use the current version at your own risk. Thanks.
<!-- warning:end -->

<!-- usage:start -->
## Usage

<details open>
  <summary>
    <h3 style="display: inline-block;">
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
        service_class.class_exec do
          include ConvenientService::Standard::Config
        end
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
      return failure(data: {path: "Path is `nil'"}) if path.nil?
      return failure(data: {path: "Path is empty"}) if path.empty?

      return error(message: "File with path `#{path}' does NOT exist") unless ::File.exist?(path)

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
      return failure(data: {path: "Path is `nil'"}) if path.nil?
      return failure(data: {path: "Path is empty"}) if path.empty?

      return error(message: "File with path `#{path}' is empty") if ::File.zero?(path)

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
      return failure(data: {path: "Path is `nil'"}) if path.nil?
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
<!-- usage:end -->

---

<!-- author:start -->
Copyright (c) 2022 [Marian Kostyk](http://mariankostyk.com).
<!-- author:end -->
