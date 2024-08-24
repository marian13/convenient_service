# Backlog

\***Priority levels:** Low, Medium, High, Critical, Unknown.

\***Complexity levels:** Easy, Moderate, Hard, Extreme, Unknown.

\*Different naming conventions for priority and complexity are used intentionally to simplify task lookup.

---

## Docs

### Write comprehensive user docs

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | High | TODO | docs, user-docs |

Describe every available [Conveninet Service](https://userdocs.convenientservice.org) feature at least once.

**Notes:**

- This is a crucial task before the v1.0.0 release.

- [Convenient Service User Docs](https://userdocs.convenientservice.org).

---

### Add YARD type signatures for the whole codebase

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | yard, yard-tags, api-docs |

Ensure YARD type signatures are properly rendered in the [Convenient Service API docs](https://apidocs.convenientservice.org).

**Notes:**

- This is a crucial task before the v1.0.0 release.

- [YARD tags](https://rubydoc.info/gems/yard/file/docs/Tags.md#taglist).

- [Convenient Service API docs](https://apidocs.convenientservice.org).

---

### Show an example of `id_or_record` attribute

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Easy | TODO | id-or-record, attributes |

**Notes:**

- [Rails Attribute API](https://api.rubyonrails.org/classes/ActiveRecord/Attributes/ClassMethods.html).

---

## Promotion

### Add Convenient Service to the Ruby Toolbox Catalogue

Once the first major version is released, add [Convenient Service](https://github.com/marian13/convenient_service) to the [Ruby Toolbox Catalogue](https://www.ruby-toolbox.com/categories/Service_Objects).

Open a PR that modifies the following [file](https://github.com/rubytoolbox/catalog/blob/main/catalog/Code_Organization/Service_Objects.yml).

---

## Features

### Introduce per-requesr caching of steps using Rails Current Attributes

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | per-request-cache, cached-steps, current-attributes |

A killer feature.

**Notes:**

- [Rails Current Attributes](https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html).

### Introduce concurent/parallel steps

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | Extreme | TODO | concurent-steps, parallel-steps |

A killer feature.

---

### Introduce recoverable services

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | Extreme | TODO | recoverable-services |

A killer feature.

---

### Introduce results enumerator

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Moderate | Extreme | TODO | results-enumerator |

```ruby
enum = service.to_results_enum.lazy.select { ... }

result = enum.next
```

---

### Introduce a DSL to add heredocs to failure and error messages

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Moderate | TODO | hereredoc, failures, errors |

---

### Track `receive counts` for `delegate_to`

**Notes:**

- Check [receive counts](https://relishapp.com/rspec/rspec-mocks/docs/setting-constraints/receive-counts) from RSpec.

---

### Consider to introduce DSL for high-order services

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Hard | TODO | high-order-services |

---

### Consider to introduce `delegate_to_service`

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Moderate | TODO | delegate-to-service |

---

### Consider to introduce `.and_return(instance_of(expected))`

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Moderate | TODO | and_return, rspec-argument-matcher |

---

### Add a way to select diff algorithm

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Moderate | TODO | delegate_to, diff_algorithm, diffy |

`ConvenientService::Config.delegate_to_diff_algorithm = :diffy`

---

### Rubocop cop that complains when a service name does NOT start with a verb

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Hard | TODO | rubocop-cop, service-name, start-with-verb |

---

### Create a generator for service specs boilerplate

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | Hard | TODO | generator, specs-boilerplate |

A killer feature.

---

### Rubocop cop that complains when a service does NOT have its own suite of specs

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | rubocop-cop, missing-direct-specs |

---

### Consider to introduce inline steps

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | inline-steps |

---

### Allow to define method middleware caller with visibility

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Moderate | TODO | public, protected, private, method-middleware-caller |

---

### Introduce an ability to uninclude configs

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | High | TODO | config, uninclude |

For example:

```ruby
class Service
  include ConvenientService::Standard::Config

  include ConvenientService::FaultTolerance::Config

  uninclude ConvenientService::FaultTolerance::Config

  def result
    success
  end
end
```

Otherwise, the config inclusion API must be changed before v1.0.0.

**Notes:**

- [Uninclude](https://github.com/rosylilly/uninclude).

- [add uninclude and unextend method](https://bugs.ruby-lang.org/issues/8967).

- [Add uninclude please](https://bugs.ruby-lang.org/issues/9887?tab=history).

- [rb_include_module(VALUE klass, VALUE module)](https://github.com/ruby/ruby/blob/v3_3_4/class.c#L1179).

---

### Minitests assertions

---

## Internals

### Consider to replace `CachesReturnValue`

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | performance-optimization, CachesReturnValue |

Services and steps are caching their results utilizing the `CachesReturnValue` plugin.

Although it is very flexible and easy to reuse from a maintenance point of view, that is not the best option from a performance point of view.

If it starts to cause any visible performance penalty, it can be refactored using regular `||=` or `if defined?`.

---

### Consider creating parent results while copying results

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | parent-result |

Fallbacks have no access to their original results.

When a fallback result is used, the original result is NOT in the parent's chain.

Is it OK?

---

### Consider making result codes `Symbol` descendants

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | result-code, case-when, symbol-descendant |

This way the code below:

```ruby
if result.not_success?
  case result.code.to_sym
  when :full_queue
    notify_devops
  when :duplicated_job
    notify_devs
  else
    # ...
  end
end
```

Can be rewritten as follows:

```ruby
if result.not_success?
  case result.code
  when :full_queue
    notify_devops
  when :duplicated_job
    notify_devs
  else
    # ...
  end
end
```

That leads to more idiomatic and natural Ruby.

---

### Pass method name to `TooManyCommitsFromMethodMissing` exception

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | config, method-missing, auto-commit |

The `TooManyCommitsFromMethodMissing` exception is already beneficial.

```ruby
##
# `Service` config is committed too many times from `method_missing`.
# In order to resolve this issue try to commit it manually before usage of any config-dependent method.
#
# Example 1 (outside class):
#   # Commitment:
#   Service.commit_config!
#
#   # Few lines later - usage:
#   Service.result # or whatever method.
#
# Example 2 (inside class):
#
#   class Service
#     # ...
#     commit_config!
#
#     step :result # or any other method that becomes available after config commitment.
#   end
```

However, it does not give any information on which exact method causes too many method-missing invocations.

---

### Move `internals` into `Core`

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | internals, core |

**Notes:**

- Provide a simple way to add new instance/class methods to internals.

---

### Extract auto commitment behavior from the `Core` into a separate concern

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Hard | TODO | core, auto-commitment |

**Notes:**

- Ensure it can be easily integrated with other extractions, e,g: new middleware backend.

- Probably inheritance is a compromise way to go for now.

---

### Convert the `Specification` module into a singleton class

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Low | TODO | specification, gemspec, singleton |

- That is required to have a simple way to test the `gemspec` by RSpec.

  For example, the `spec.files` config is very error-prone, but it has no reliable specs for now.

  ```ruby
  module ConvenientService
    class Specification
      include ::Singleton

      # ...

      def to_gemspec
        # ...
      end
    end
  end
  ```

---

### Add Dockerfiles for TruffleRuby 23.0 and 24.0

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Moderate | TODO | truffle-ruby, dockerfile |

**Notes:**

- [TruffleRuby 24 Docker image](https://github.com/graalvm/container/pkgs/container/truffleruby-community/193001493?tag=24.0.0).

- [TruffleRuby 23 Docker image](https://github.com/graalvm/container/pkgs/container/truffleruby-community/103900821?tag=23.0.0).

- [List of available TruffleRuby Docker images](https://github.com/graalvm/container/pkgs/container/truffleruby-community/versions?filters%5Bversion_type%5D=tagged).

- Consider to add [TruffleRuby to CI](https://github.com/marketplace/actions/setup-ruby-jruby-and-truffleruby).

---

### Provide a way to use trailing ENV variables in go-tasks

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | Unknown | TODO | go-task, Taskfile, leading-env-variable, trailing-env-variable |


The following command (`task docker:build`) works in both cases.

With leading ENV variables.

```bash
RUBY_ENGINE=ruby RUBY_VERSION=2.7 task docker:build
```

With trailing ENV variables.

```bash
task docker:build RUBY_ENGINE=ruby RUBY_VERSION=2.7
```

But at the same time`task rspec` works only with leading ENV variables.

```bash
APPRAISAL=rails_7.0 task rspec
```

That is happening because `task rspec` accesses `APPRAISAL` using [Dynamic Variables](https://taskfile.dev/usage/#dynamic-variables).

**Notes:**

- Consider to open a [Github issue](https://github.com/go-task/task/issues).

---

### Leverage RequestStore

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Hard | TODO | request-store |

Use [RequestStore](https://github.com/steveklabnik/request_store) or [RequestStore::Fibers](https://github.com/BMorearty/request_store-fibers) when available? | Any additional changes for [RequestStore::Sidekiq](https://github.com/madebylotus/request_store-sidekiq)? Check [RuboCop::ThreadSafety](https://github.com/rubocop/rubocop-thread_safety?tab=readme-ov-file#correcting-code-for-thread-safety) for details.

---

### Do not use testing toolkit in the primitives layer

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | layers |

See [Components Diagram](https://marian13.github.io/static_content/convenient_service/diagrams/components_graph.html) + it should take the minimal amount of efforts to extract and reuse `Utils`, `Suppport` in the different projects.

---

### Resolve warning during specs

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | warning, specs |

---

### Move callbacks and steps to internals

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | High | TODO | internals, callbacks, steps |

In order to NOT pollute the public interface of users services.

---

### Introduce custom RSpec matcher to track `ConvenientService::Logger` messages

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | Hard | TODO | logger, custom-matcher |

---

### Remove dependency containers

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | dependency-containers |

---

### Write custom middleware backend

---

### Optimize `stack.dup` in `MethodMiddlewares#call`

---

### Make a decision of what to do with `printable_block` in custom RSpec matchers

---

### Consider to change/rewrite `delegate` backend to minify its interface

---

### Ensure same order of attr macros, delegators, initialize, class methods, attr methods, queries, actions, `to_*`, comparison, inspect

---

### Consider to create `ComparableProc` descendant from `Proc`

To abstract away `block&.source_location != other.block&.source_location`

---

### Consider to use `Struct` as key in `Support::Cache`

To hide overriden [eql?](https://github.com/marian13/convenient_service/blob/v0.1.0/lib/convenient_service/common/plugins/caches_return_value/entities/key.rb#L60)

---

## Tests

### Intentionally disable plugins to document dependencies

---

### Mutant testing

---

### Introduce thread-safety tests

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Hard | TODO | thread-safety |

---

## Performance

### Perfromance testing

[rspec-benchmark](https://github.com/piotrmurach/rspec-benchmark), [Testing object allocations](https://www.honeybadger.io/blog/testing-object-allocations/), [allocation_stats](https://github.com/srawlins/allocation_stats).

---

### Measure performance of deeply nested steps

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | performance, deeply-nested-steps |

---

### Measure performance of huge amount of included modules

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Moderate | TODO | performance, included-modules |

## Memory

### Consider to drop references to already calculated steps

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | High | TODO | memory, drop-calculated-steps |

**Drawbacks:**

- Services that do NOT keep references to already calculated steps can NOT utilize `CanHaveRollbacks` plugin.

---

## Licence

### Complete licence files

- Commercial Support docs. See [Sidekiq Commercial Support](https://github.com/sidekiq/sidekiq/wiki/Commercial-Support).

- Acknowledgements - Government End Users. See [GraphQL Ruby Commercial Licence](https://graphql.pro/COMM-LICENSE.html).

- Applicable Law and Jurisdiction (Miscellaneous - Governing Law). See [Kiba Applicable Law and Jurisdiction](https://github.com/thbar/kiba/blob/master/COMM-LICENSE.md).

- Contact email `info@convenientservice.org`.

- Contributing Guide. See [Sidekiq Contributing](https://github.com/sidekiq/sidekiq/blob/main/.github/contributing.md).

---

Search for `TODO`s in the codebase or check [discussions](https://github.com/marian13/convenient_service/discussions) for more tasks.
