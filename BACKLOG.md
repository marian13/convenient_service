# Backlog

\***Priority levels:** Low, Medium, High, Critical.

\***Complexity levels:** Easy, Moderate, Hard, Extreme.

\*Different naming conventions for priority and complexity is used intentionally to simplify task lookup.

----

### Allow to include `Core` only into classes

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | core |

**Notes:**

- Place a check inside in the beginning of the `included` block.
  ```ruby
  included do |entity_class|
    # ...

    entity_class.include Concern
  end
  ```

- See [lib/convenient_service/core.rb](https://github.com/marian13/convenient_service/blob/v0.18.0/lib/convenient_service/core.rb#L18).

----

### Extract auto commitment behaviour from `Core` into separate concern

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Hard | TODO | core, auto-commitment |

**Notes:**

- Ensure it can be easily integrated with other extractions.

- Probably inheritance is a way to go for now.

----

### Implement `amazing print` based config since `awesome_print` became stale

| Priority | Complexity | Status | Tags |
| - | - | - | - |
| Medium | Easy | TODO | configs, pretty-print, awesome-print, amazing-print |

**Notes:**

- [amazing_print](https://github.com/awesome-print/awesome_print) has the same issues with Ruby 3 as [awesome_print](https://github.com/awesome-print/awesome_print).

- Leave a note about minimal [amazing_print](https://github.com/awesome-print/awesome_print) version that has no issues with Ruby 3 in the user docs.

- Use `AwesomePrintInspect` as a example.

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

----

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

----

