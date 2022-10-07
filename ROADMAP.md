# Roadmap

| Priority | Status | Goal | Notes |
| - | - | - | - |
| High | ⏳ | 100% coverage of `Core` | |
| Medium | 🚧 | Type signatures for the whole codebase ([Yard @param, @overload, @return](https://rubydoc.info/gems/yard/file/docs/Tags.md#taglist)) | |
| Medium | 🚧 | `Service.success?` shortcut for `Service.result.success?` | |
| Medium | 🚧 | Release `v0.1.0` with a warning that lib is still under heavy development | |
| Medium | 🚧 | [Active Record transaction](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html) examples | |
| Low | 🚧 | [Capybara](https://github.com/teamcapybara/capybara) examples | |
| Low | 🚧 | [Thread.current](https://ruby-doc.org/core-3.1.2/Thread.html#method-c-current) to cache repetable nested steps during an organizer invocation | |
| Medium | 🚧 | Inline step sequence | |
| High | 🚧 | Move callbacks to internals | |
| Low | 🚧 | Create an example of `id_or_record` [attribute](https://api.rubyonrails.org/classes/ActiveRecord/Attributes/ClassMethods.html) |
| Low | 🚧 | GitHub Wiki/Gists for Support | |
| Low | 🚧 | Contribute to Shoulda Matchers | |
| High | 🚧 | `respond_to_missing?` | |
| Medium | ⏳ | Custom matcher to track `ConvenientService::Logger` messages | |
| Medium | 🚧 | Remove `respond_to?` from `Copyable` | Investigate before making any decision |
| High | 🚧 | Unified `inspect` | |
| High | ✅ | Remove race condition for `method_missing` | https://github.com/marian13/convenient_service/pull/5 |
| High | 🚧 | Remove incompatiility of [Module#include](https://gist.github.com/marian13/9c25041f835564e945d978839097d419) | |
| Medium | 🚧 | Split `Utils` specs into separate files | |
| Medium | 🚧 | How to test thread-safety? | |
