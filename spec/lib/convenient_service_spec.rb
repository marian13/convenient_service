# frozen_string_literal: true

require "convenient_service"

RSpec.describe ConvenientService do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  example_group "constants" do
    describe "::VERSION" do
      it "returns version" do
        expect(described_class::VERSION).to be_instance_of(String)
      end

      it "follows Semantic Versioning" do
        expect(described_class::VERSION).to match(/\d+\.\d+\.\d+/)
      end
    end
  end

  example_group "class methods" do
    describe ".logger" do
      it "returns logger instance" do
        expect(described_class.logger).to eq(described_class::Logger.instance)
      end
    end

    describe ".root" do
      it "returns Convenient Service root folder" do
        expect(described_class.root).to eq(Pathname.new(Dir.pwd))
      end
    end

    describe ".examples_root" do
      it "returns Convenient Service Examples root folder" do
        expect(described_class.examples_root).to eq(Pathname.new(File.join(Dir.pwd, "lib", "convenient_service", "examples")))
      end
    end

    describe ".backtrace_cleaner" do
      it "returns backtrace cleaner" do
        expect(described_class.backtrace_cleaner).to be_instance_of(ConvenientService::Support::BacktraceCleaner)
      end

      specify do
        expect { described_class.backtrace_cleaner }.to cache_its_value
      end
    end
  end
end
