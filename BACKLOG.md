# Backlog

\***Priority levels:** Low, Medium, High, Critical, Unknown.

\***Complexity levels:** Easy, Moderate, Hard, Extreme, Unknown.

\*Different naming conventions for priority and complexity are used intentionally to simplify task lookup.

---

### Allow to include `Core` only in classes

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | core |

**Notes:**

- Place a check at the beginning of the `included` block.
  ```ruby
  included do |entity_class|
    # ...

    entity_class.include Concern
  end
  ```

- See [lib/convenient_service/core.rb](https://github.com/marian13/convenient_service/blob/v0.18.0/lib/convenient_service/core.rb#L18).

---

### Extract auto commitment behavior from the `Core` into a separate concern

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Hard | TODO | core, auto-commitment |

**Notes:**

- Ensure it can be easily integrated with other extractions, e,g: new middleware backend.

- Probably inheritance is a compromise way to go for now.

---

### Implement `amazing print` based config since `awesome_print` became stale

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | configs, pretty-print, awesome-print, amazing-print |

**Notes:**

- [amazing_print](https://github.com/awesome-print/awesome_print) has the same issues with Ruby 3 as [awesome_print](https://github.com/awesome-print/awesome_print).

- Leave a note about the minimal [amazing_print](https://github.com/awesome-print/awesome_print) version that has no issues with Ruby 3 in the user docs.

- Use `AwesomePrintInspect` as an example.

  ```ruby
  module ConvenientService
    module Service
      module Configs
        module AwesomePrintInspect
          # ...
        end
      end
    end
  end
  ```

---

### Inline `NormalizesEnv` middleware into `Core`

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | Moderate | TODO | normalizes-env, middleware, new-method |

- That is required to remove the necessity to specify `NormalizesEnv` middleware explicitly for newly registered methods.

  ```ruby
  module ConvenientService
    module Service
      module Configs
        module Essential
          # ...
          middlewares :result do
            # This should be internal.
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware

            # ...
          end
        end
      end
    end
  end
  ```

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

### Add Convenient Service to the Ruby Toolbox Catalogue

Once the first major version is released, add [Convenient Service](https://github.com/marian13/convenient_service) to the [Ruby Toolbox Catalogue](https://www.ruby-toolbox.com/categories/Service_Objects).

- Open a PR that modifies the following [file](https://github.com/rubytoolbox/catalog/blob/main/catalog/Code_Organization/Service_Objects.yml).

---

### Respect service last step `out` aliases

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| High | Moderate | Done | last-step, out-alias |

Resolved by [b8285e3](https://github.com/marian13/convenient_service/commit/b8285e33c764a61bd8fa1df6e126e45c4491a5a6).

- Consider the following services:

  ```ruby
  class LastStep
    include ConvenientService::Standard::Config

    def result
      success(foo: "foo")
    end
  end

  class ServiceWithSteps
    include ConvenientService::Standard::Config

    step LastStep,
      out: {foo: :bar}
  end
  ```

- `ServiceWithSteps.result` returns `LastStep.result`, but it ignores `out` alias.

  In other words, `ServiceWithSteps.result.data[:bar]` raises an exception.

  That is not intuitive.

---

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

Otherwise, the config inclusion API must be changes before v1.0.0.

**Notes:**

- [Uninclude](https://github.com/rosylilly/uninclude).

- [add uninclude and unextend method](https://bugs.ruby-lang.org/issues/8967).

- [Add uninclude please](https://bugs.ruby-lang.org/issues/9887?tab=history).

---

## Memory

### Consider to drop references to already calculated steps

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Low | High | TODO | memory, drop-calculated-steps |

**Drawbacks:**

- Services that do NOT keep references to already calculated steps can NOT utilize `CanHaveRollbacks` plugin.
