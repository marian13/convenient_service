# frozen_string_literal: true

##
# Usage:
#
#   ConvenientService::Examples::Standard::V1::Gemfile::Services::StripComments.result(content: "abc")
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class StripComments
              include ConvenientService::Standard::V1::Config

              attr_reader :content

              alias_method :content_with_comments, :content

              step Services::AssertNpmPackageAvailable, in: {name: -> { "strip-comments" }}
              step Services::RunShellCommand, in: {command: -> { "node -e '#{js_script}' #{file_with_comments.path} #{file_without_comments.path}" }}
              step :result, in: :file_without_comments, out: :content_without_comments

              def initialize(content:)
                @content = content
              end

              def result
                success(data: {content_without_comments: file_without_comments.read})
              end

              private

              ##
              # NOTE: When you have no time to do something well, delegate that task to someone who already works with it all the time.
              # That is why `strip-comments` npm package is used to remove comments.
              #
              def js_script
                ##
                # NOTE: `main` function is created in order to have an ability to use early returns.
                #
                # IMPORTANT: Use only double quotes inside this JS script, since it is later consumed by `node -e` option wrapped by single quoutes.
                #
                # TODO: Consider to use WeakRef if memory is a concern.
                # https://ruby-doc.org/stdlib-2.5.1/libdoc/weakref/rdoc/WeakRef.html
                #
                # TODO: Jest tests for JS script.
                #
                @js_script ||= <<~JAVASCRIPT.gsub(/\n\s*/, " ")
                  const main = () => {
                    const process = require("process");
                    const fs = require("fs");

                    /**
                     * TODO: try/catch when "strip-comments" is not available.
                     */
                    const strip = require("strip-comments");

                    const fileWithCommentsPath = process.argv[1];
                    const fileWithoutCommentsPath = process.argv[2];
                    const language = process.argv[3] || "ruby";

                    if (!fileWithCommentsPath) {
                      console.log("Error: Input file path is NOT passed.");

                      process.exit(1);
                    }

                    if (!fileWithoutCommentsPath) {
                      console.log("Error: Output file path is NOT passed.");

                      process.exit(1);
                    }

                    if (!["ruby", "javascript"].includes(language)) {
                      console.log("Error: Language " + language + " is NOT supported.");

                      process.exit(1);
                    }

                    const fileWithCommentsContent = fs.readFileSync(fileWithCommentsPath, { encoding: "utf8" });
                    const fileWithoutCommentsContent = strip(fileWithCommentsContent, { language });

                    fs.writeFileSync(fileWithoutCommentsPath, fileWithoutCommentsContent, { encoding: "utf8" });

                    process.exit(0);
                  };

                  main();
                JAVASCRIPT
              end

              def file_with_comments
                ##
                # NOTE: Tempfile is used to avoid issues with escaping of quotes inside JS script.
                #
                @file_with_comments ||= ::Tempfile.new.tap { |tempfile| tempfile.write(content_with_comments) }.tap(&:close)
              end

              def file_without_comments
                ##
                # NOTE: JS script tries to fill content of the file without comments.
                #
                @file_without_comments ||= ::Tempfile.new
              end
            end
          end
        end
      end
    end
  end
end
