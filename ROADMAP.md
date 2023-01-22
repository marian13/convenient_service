# Roadmap

| Priority | Status | Goal | Notes |
| - | - | - | - |
| High | ✅ | 100% coverage of `Core` | |
| Medium | 🚧 | Type signatures for the whole codebase ([Yard @param, @overload, @return](https://rubydoc.info/gems/yard/file/docs/Tags.md#taglist)) | |
| Medium | ✅ | `Service.success?` shortcut for `Service.result.success?` | |
| Medium | ✅ | Release `v0.1.0` with a warning that lib is still under heavy development | |
| Medium | 🚧 | [Active Record transaction](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html) examples | |
| Medium | 🚧 | [Rails Current Attributes integration](https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html) to cache repeated results | |
| Low | 🚧 | [Capybara](https://github.com/teamcapybara/capybara) examples | |
| Medium | 🚧 | Inline step sequence | |
| High | 🚧 | Move callbacks to internals | |
| Low | 🚧 | Create an example of `id_or_record` [attribute](https://api.rubyonrails.org/classes/ActiveRecord/Attributes/ClassMethods.html) |
| Low | 🚧 | GitHub Wiki/Gists for Support | |
| Low | 🚧 | Contribute to Shoulda Matchers | |
| High | ✅ | `respond_to_missing?` | [ConvenientService::Core::ClassMethods#respond_to_missing?](https://github.com/marian13/convenient_service/blob/main/lib/convenient_service/core/class_methods.rb#L105), [ConvenientService::Core::InstanceMethods#respond_to_missing?](https://github.com/marian13/convenient_service/blob/main/lib/convenient_service/core/instance_methods.rb#L30) |
| High | ⏳ | Custom matcher to track `ConvenientService::Logger` messages | |
| Medium | 🚧 | Remove `respond_to?` from `Copyable` | Investigate before making any decision |
| High | 🚧 | Unified `inspect` | Remove `internals` from inspect, ivars wrapperd by double underscore |
| High | ✅ | Remove race condition for `method_missing` | https://github.com/marian13/convenient_service/pull/5 |
| High | ✅ | Remove incompatiility of [Module#include](https://gist.github.com/marian13/9c25041f835564e945d978839097d419) | https://github.com/marian13/convenient_service/pull/3 |
| Medium | ✅ | Split `Utils` specs into separate files | [convenient_service/spec/lib/convenient_service/utils](https://github.com/marian13/convenient_service/tree/main/spec/lib/convenient_service/utils) |
| Medium | 🚧 | How to test thread-safety? | |
| Medium | ✅ | Rename `Utils::Module.find_own_const` to `Utils::Module.get_own_const` | [ConvenientService::Utils::Module::GetOwnConst](https://github.com/marian13/convenient_service/blob/main/lib/convenient_service/utils/module/get_own_const.rb) |
| Medium | 🚧 | Mark `@api private` methods, classes | [YARD Tags](https://www.rubydoc.info/gems/yard/file/docs/Tags.md) |
| Medium | ✅ | A way to check if block has one required positional argument | [#proc_has_one_positional_argument?](https://github.com/marian13/convenient_service/blob/main/lib/convenient_service/utils/proc/exec_config.rb#L96) |
| Low | 🚧 | Define method middleware caller with visibility | |
| Low | 🚧 | Dependency containers to remove high coupling | |
| Low | 🚧 | Measure performance | |
| Low | 🚧 | Rewrite middleware backend to count [convenient_service](https://github.com/marian13/convenient_service) specifics | |
| High | 🚧 | Optimize `stack.dup` in `MethodMiddlewares#call` | Core v3 |
| Medium | 🚧 | Make a decision of what to do with `printable_block` in custom RSpec matchers | |
| Medium | 🚧 | User-friendly exception messages | |
| High | 🚧 | Factories for POROs in specs ❗❗❗ | Start with `result_class`, `class self::Result`, `service_class`, `step_class`, `organizer_class` |
| High | 🚧 | Resolve warning during specs | |
| Medium | 🚧 | Consider to change/rewrite `delegate` backend to minify its interface | |
| Medium | 🚧 | Same order of attr macros, delegators, initialize, class methods, attr methods, queries, actions, `to_*`, comparison, inspect | |
| Medium | ✅ | Move `Cache` to `Support` | |
| Medium | 🚧 | Statically specify plugin dependencies | |
| Medium | 🚧 | Statically specify plugin entity types | |
| Medium | 🚧 | Consider to create `ComparableProc` descendant from `Proc` | To abstract away `block&.source_location != other.block&.source_location` |
| Medium | 🚧 | Consider to use `Struct` as key in `Support::Cache` | To hide overriden [eql?](https://github.com/marian13/convenient_service/blob/v0.1.0/lib/convenient_service/common/plugins/caches_return_value/entities/key.rb#L60) |
| High | 🚧 | `included_once` for `Support::Concern` |
| Medium | 🚧 | Custom YARD type for service instance, service class as return values |
| Medium | 🚧 | Heredoc for error messages |
| Medium | 🚧 | Specs for `be_success`, `be_error`, `be_failure` matchers | |
| Low | 🚧 | [Receive Counts](https://relishapp.com/rspec/rspec-mocks/docs/setting-constraints/receive-counts) for `delegate_to` | |
| Low | 🚧 | Prefer versioning instead of modification plugin | |
| Low | 🚧 | Consider to move `__steps__` and `__callbacks__` to `internals_class` | Benefit? |
| Medium | 🚧 | User friendly `raise` that removes lib backtrace from caller | Should have a `debug` mode. Should work well with examples. Check RSpec `CallerFilter.first_non_rspec_line` |
| High | 🚧 | A plugin that catches `StandardError` and returns `failure` | Should be the lowest in the stack |
| High | 🚧 | `Support::Command` alias | Should be visible to the end user |
| Low | 🚧 | Parallel steps | A killer feature |
| Medium | 🚧 | Add `Ruby 3.2` support to `Docker` and `CI` |  |
| Low | 🚧 | `overload do` | |
| Low | 🚧 | Same spec example group organization | |
| Medium | 🚧 | `Support::Arguments` | |
| Low | 🚧 | Null object to Nil object? | |
| High | 🚧 | Do not use Testing Toolkit in the Primitives layer | See [Components Diagram](https://marian13.github.io/static_content/convenient_service/diagrams/components_graph.html) + it should take the minimal amount of efforts to extract and reuse `Utils`, `Suppport` in the different projects |
| Medium | 🚧 | Perfromance testing | [rspec-benchmark](https://github.com/piotrmurach/rspec-benchmark), [Testing object allocations](https://www.honeybadger.io/blog/testing-object-allocations/), [allocation_stats](https://github.com/srawlins/allocation_stats) |
| Medium | 🚧 | Mutant testing | [mutant](https://github.com/mbj/mutant) |
| Low | 🚧 | Add `JRuby` support | [jruby](https://www.jruby.org/) |
| Medium | 🚧 | Add `shoulda-context` to test conditionals when `RSpec` is not loaded | [shoulda-context](https://github.com/thoughtbot/shoulda-context) |
| High | 🚧 | Abstract factory for `CastMethod` | |
| Medium | 🚧 | `delegate_to` - option to specify of how to compare blocks | |

Search for `TODO`s in the codebase for more tasks.
