# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService, type: :standard do
  include described_class::RSpec::Matchers::CacheItsValue
  include described_class::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".debug?" do
      context "when `ENV[\"CONVENIENT_SERVICE_DEBUG\"]` is NOT set to `false`" do
        before do
          allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_DEBUG").and_return(nil)
        end

        it "return `false`" do
          expect(described_class.debug?).to eq(false)
        end
      end

      context "when `ENV[\"CONVENIENT_SERVICE_DEBUG\"]` is set to `\"true\"`" do
        before do
          allow(ENV).to receive(:[]).with("CONVENIENT_SERVICE_DEBUG").and_return("true")
        end

        it "return `true`" do
          expect(described_class.debug?).to eq(true)
        end
      end
    end

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

    describe ".lib_root" do
      it "returns Convenient Service lib folder" do
        expect(described_class.lib_root).to eq(Pathname.new(File.join(Dir.pwd, "lib")))
      end
    end

    describe ".examples_root" do
      it "returns Convenient Service Examples root folder" do
        expect(described_class.examples_root).to eq(Pathname.new(File.join(Dir.pwd, "lib", "convenient_service", "examples")))
      end
    end

    describe ".spec_root" do
      it "returns Convenient Service Specs root folder" do
        expect(described_class.spec_root).to eq(Pathname.new(File.join(Dir.pwd, "spec")))
      end
    end

    describe ".backtrace_cleaner" do
      it "returns backtrace cleaner" do
        expect(described_class.backtrace_cleaner).to be_instance_of(described_class::Support::BacktraceCleaner)
      end

      specify do
        expect { described_class.backtrace_cleaner }.to cache_its_value
      end
    end

    describe ".raise" do
      ##
      # IMPORTANT: CRuby `Kernel.raise` supports `cause` keyword starting from 2.6.
      # JRuby 9.4 says that it is Ruby 3.1 compatible, but it still does NOT support `cause` keyword.
      # - https://ruby-doc.org/core-2.5.0/Kernel.html#method-i-raise
      # - https://ruby-doc.org/core-2.6/Kernel.html#method-i-raise
      # - https://github.com/jruby/jruby/blob/9.4.0.0/core/src/main/java/org/jruby/RubyKernel.java#L881
      # - https://github.com/ruby/spec/blob/master/core/kernel/raise_spec.rb#L5
      #
      if described_class::Dependencies.ruby.match?("jruby < 10.1")
        let(:exception) do
          raise Class.new(StandardError), "Custom message", ["#{described_class.root}/foo.rb"]
        rescue => error
          error
        end
      else
        let(:exception) do
          raise Class.new(StandardError), "Custom message", ["#{described_class.root}/foo.rb"], cause: Class.new(StandardError).new
        rescue => error
          error
        end
      end

      it "raises `exception` with `class` and `message`" do
        expect { described_class.raise(exception) }
          .to raise_error(exception.class)
          .with_message(exception.message)
      end

      if !described_class::Dependencies.ruby.match?("jruby < 10.1")
        # rubocop:disable RSpec/MultipleExpectations
        it "raises `exception` with `cause`" do
          expect { described_class.raise(exception) }.to raise_error { |error| expect(error.cause.class).to eq(exception.cause.class) }
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when backtrace cleaner has no silencers" do
        before do
          allow(described_class).to receive(:backtrace_cleaner).and_return(described_class::Support::BacktraceCleaner.new.tap(&:remove_silencers!))
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT clean `exception` backtrace" do
          expect { described_class.raise(exception) }.to raise_error { |error| expect(error.backtrace.none? { |line| line.start_with?(described_class.root.to_s) }).to eq(false) }
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when backtrace cleaner has any silencer" do
        before do
          allow(described_class).to receive(:backtrace_cleaner).and_return(described_class::Support::BacktraceCleaner.new.tap(&:add_convenient_service_silencer))
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "cleans `exception` backtrace" do
          expect { described_class.raise(exception) }.to raise_error { |error| expect(error.backtrace.none? { |line| line.start_with?(described_class.root.to_s) }).to eq(true) }
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    describe ".reraise" do
      context "when `block` does NOT raise exception" do
        let(:block) { proc { value } }
        let(:value) { :foo }

        it "returns `block` value" do
          expect(described_class.reraise(&block)).to eq(value)
        end
      end

      context "when `block` raises `exception`" do
        ##
        # IMPORTANT: CRuby `Kernel.raise` supports `cause` keyword starting from 2.6.
        # JRuby 9.4 says that it is Ruby 3.1 compatible, but it still does NOT support `cause` keyword.
        # - https://ruby-doc.org/core-2.5.0/Kernel.html#method-i-raise
        # - https://ruby-doc.org/core-2.6/Kernel.html#method-i-raise
        # - https://github.com/jruby/jruby/blob/9.4.0.0/core/src/main/java/org/jruby/RubyKernel.java#L881
        # - https://github.com/ruby/spec/blob/master/core/kernel/raise_spec.rb#L5
        #
        if described_class::Dependencies.ruby.match?("jruby < 10.1")
          let(:exception) do
            raise Class.new(StandardError), "Custom message", ["#{described_class.root}/foo.rb"]
          rescue => error
            error
          end

          let(:block) { proc { raise exception.class, exception.message, exception.backtrace } }
        else
          let(:exception) do
            raise Class.new(StandardError), "Custom message", ["#{described_class.root}/foo.rb"], cause: Class.new(StandardError).new
          rescue => error
            error
          end

          let(:block) { proc { raise exception.class, exception.message, exception.backtrace, cause: exception.cause } }
        end

        it "raises that `exception` with `class` and `message`" do
          expect { described_class.reraise(&block) }
            .to raise_error(exception.class)
            .with_message(exception.message)
        end

        if !described_class::Dependencies.ruby.match?("jruby < 10.1")
          # rubocop:disable RSpec/MultipleExpectations
          it "raises that `exception` with `cause`" do
            expect { described_class.reraise(&block) }.to raise_error { |error| expect(error.cause.class).to eq(exception.cause.class) }
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when backtrace cleaner has no silencers" do
          before do
            allow(described_class).to receive(:backtrace_cleaner).and_return(described_class::Support::BacktraceCleaner.new.tap(&:remove_silencers!))
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT clean `exception` backtrace" do
            expect { described_class.reraise(&block) }.to raise_error { |error| expect(error.backtrace.none? { |line| line.start_with?(described_class.root.to_s) }).to eq(false) }
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when backtrace cleaner has any silencer" do
          before do
            allow(described_class).to receive(:backtrace_cleaner).and_return(described_class::Support::BacktraceCleaner.new.tap(&:add_convenient_service_silencer))
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "cleans `exception` backtrace" do
            expect { described_class.reraise(&block) }.to raise_error { |error| expect(error.backtrace.none? { |line| line.start_with?(described_class.root.to_s) }).to eq(true) }
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
