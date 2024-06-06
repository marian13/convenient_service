# frozen_string_literal: true

require "yard"

module YARD
  module CLI
    class Yardoc < YardoptsCommand
      ##
      # Excludes the following classes from `all_objects`.
      #   Registry.all(:root, :module, :class).select { |object| object.path.include?(".self") }
      #   =>
      #   [
      #     #<yardoc class ConvenientService::Service::Configs::Standard.self::Result>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Internals>,
      #     #<yardoc class ConvenientService::Service::Configs::Standard::V1.self::Result>,
      #     #<yardoc class ConvenientService::Service::Configs::AmazingPrintInspect.self::Result>,
      #     #<yardoc class ConvenientService::Service::Configs::AwesomePrintInspect.self::Result>,
      #     #<yardoc class ConvenientService::Service::Configs::AwesomePrintInspect.self::Result.self::Data>,
      #     #<yardoc class ConvenientService::Service::Configs::AwesomePrintInspect.self::Result.self::Message>,
      #     #<yardoc class ConvenientService::Service::Configs::AwesomePrintInspect.self::Result.self::Code>,
      #     #<yardoc class ConvenientService::Service::Configs::AwesomePrintInspect.self::Result.self::Status>,
      #     #<yardoc class ConvenientService::Service::Configs::AwesomePrintInspect.self::Step>,
      #     #<yardoc class ConvenientService::Service::Configs::AmazingPrintInspect.self::Result.self::Data>,
      #     #<yardoc class ConvenientService::Service::Configs::AmazingPrintInspect.self::Result.self::Message>,
      #     #<yardoc class ConvenientService::Service::Configs::AmazingPrintInspect.self::Result.self::Code>,
      #     #<yardoc class ConvenientService::Service::Configs::AmazingPrintInspect.self::Result.self::Status>,
      #     #<yardoc class ConvenientService::Service::Configs::AmazingPrintInspect.self::Step>,
      #     #<yardoc class ConvenientService::Service::Configs::Standard::V1.self::Result.self::Status>,
      #     #<yardoc class ConvenientService::Service::Configs::Standard::V1.self::Step>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result.self::Data>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result.self::Message>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result.self::Code>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result.self::Status>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result.self::Status.self::Internals>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Result.self::Internals>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Step>,
      #     #<yardoc class ConvenientService::Service::Configs::Essential.self::Step.self::Internals>,
      #     #<yardoc class ConvenientService::Service::Configs::Standard.self::Result.self::Status>,
      #     #<yardoc class ConvenientService::Service::Configs::Standard.self::Step>
      #   ]
      #
      # @see https://github.com/lsegal/yard/issues/11#issuecomment-11926
      # @see https://github.com/lsegal/yard/blob/v0.9.36/lib/yard/cli/yardoc.rb#L330
      #
      # @note `@private` with `--no-private` option on `.yardopts` hides methods, but not classes.
      #
      # @internal
      #   TODO: Dive deep why `class self::SomeClass` is not parsed properly. Consider to open an issue/contribute.
      #
      def all_objects
        Registry.all(:root, :module, :class).reject { |object| object.path.include?(".self") }
      end
    end
  end
end
