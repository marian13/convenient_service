##
# @autor Ruby Middleware Team <https://github.com/Ibsciss/ruby-middleware>
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
# @see https://github.com/Ibsciss/ruby-middleware
##

##
# @internal
#   Yet another hack how to enable the syntax highlighting for the byebug gem. Works for v10.0.0 and higher.
#   (See https://gist.github.com/marian13/5dade20a431d7254db30e543167058ce)
#
#   WARNING: Although this hack is based on the monkey patching,
#   use this technique for other issues in your own codebases with a precaution.
#
require "byebug/runner" unless defined? Byebug::VERSION

if Gem::Version.new(Byebug::VERSION) >= Gem::Version.new("10.0.0")
  module Byebug
    class SourceFileFormatter
      ##
      # This is a replacement of the internal <tt>Byebug::SourceFileFormatter.file</tt> method
      # which adds syntax highlighting capability to it.
      #
      # The original implementation simply returns the file path
      # which is passed to the <tt>Byebug::SourceFileFormatter</tt> constructor just as <tt>file</tt>.
      # (See https://github.com/deivid-rodriguez/byebug/blob/master/lib/byebug/source_file_formatter.rb#L13)
      #
      # The current replacement, instead of returning the original file path,
      # returns a copy of it, where the syntax is highlighted by the Rouge gem(A pure Ruby code highlighter).
      # (See https://github.com/rouge-ruby/rouge)
      #
      # In order to create a copy, it utilizes Ruby's <tt>tempfile</tt> stdlib.
      # (See https://ruby-doc.org/stdlib-2.7.0/libdoc/tempfile/rdoc/Tempfile.html)
      # A tempfile is automatically deleted from the underlying OS when it is garbage-collected.
      #
      def file
        @highlighted_file ||=
          begin
            if defined? Rouge
              source = File.read(@file)

              theme     = Rouge::Themes::Monokai.new
              formatter = Rouge::Formatters::Terminal256.new(theme)
              lexer     = Rouge::Lexers::Ruby.new

              dest = formatter.format(lexer.lex(source))

              # Tempfile with the highlighted syntax is assigned to the instance variable
              # in order to prevent its premature garbage collection.
              @tempfile_with_highlighted_syntax = Tempfile.new.tap { |t| t.write(dest) }.tap(&:close)

              @tempfile_with_highlighted_syntax.path
            else
              warn %q{Rouge(a pure Ruby code highlighter) is not defined. Maybe you forgot to require it? (require 'rouge')}

              @file
            end
          end
      end
    end
  end
else
  warn "Byebug version is lower than v10.0.0..."
end
