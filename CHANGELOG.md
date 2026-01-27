<!--
  AUTHOR: Marian Kostyk <mariankostyk13895@gmail.com>
  LICENSE: LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
-->

# Changelog

## [0.22.0](https://github.com/marian13/convenient_service/compare/v0.21.1...v0.22.0) (2026-01-27)


### Features

* **arguments:** add block attr writer, nil_arguments aliases, to_arguments methods, and exceptions for null_arguments ([91ae785](https://github.com/marian13/convenient_service/commit/91ae7850166b9bfadc86b93e5c5003db4311f118))
* **results:** introduce #with_extra_keys ([1b9bd47](https://github.com/marian13/convenient_service/commit/1b9bd4750ef0412174eccc7f90c439c12dce1013))
* **results:** introduce #with_only_keys and #with_except_keys ([3f13a72](https://github.com/marian13/convenient_service/commit/3f13a7231e5852c1b04e94e27697790e4c37881b))
* **results:** introduce with_renamed_keys ([9931495](https://github.com/marian13/convenient_service/commit/9931495fe8cee57fa8fa145e72928010d3546abf))
* **step:** allow positional arguments and block as step inputs (positional arguments need Ruby 3.0+) ([558c435](https://github.com/marian13/convenient_service/commit/558c435887ae34befcd0c915166513210f37c277))
* **support:** introduce block unique value ([7009202](https://github.com/marian13/convenient_service/commit/700920224536410e10c72cecb982745daa5b53ee))

## [0.21.1](https://github.com/marian13/convenient_service/compare/v0.21.0...v0.21.1) (2025-12-31)


### Bug Fixes

* **cache:** remove scoped cache from parent when default is set to nil ([d3945d1](https://github.com/marian13/convenient_service/commit/d3945d15047ca949b88cb94e23737661c3d7913a))

## [0.21.0](https://github.com/marian13/convenient_service/compare/v0.20.0...v0.21.0) (2025-12-28)


### Features

* **call:** include tabbed original error message ([bad813a](https://github.com/marian13/convenient_service/commit/bad813aa26487d52e9972b23d41e5ca61f1d181e))
* **config:** introduce Config.available_options ([e0857e5](https://github.com/marian13/convenient_service/commit/e0857e5c2caa176fc4f64e998f8e31216a1dd210))
* **feature:** introduce Feature#to_s and Feature#inspect ([fa39639](https://github.com/marian13/convenient_service/commit/fa39639fe53aa0fcdd09c5f0e8edd6db8fe50df4))
* **forbids_convenient_service_entities_as_constructor_arguments:** add specific exception feature ([06f2e8f](https://github.com/marian13/convenient_service/commit/06f2e8fc743476ac51502f785a15ccb85332db46))
* **forbids_convenient_service_entities_as_constructor_arguments:** add specific exceptions for status, message, code, custom entity ([521f05d](https://github.com/marian13/convenient_service/commit/521f05db0cf78bd1579a7ae499725ca2c4d64a64))
* **result:** introduce Result#to_s ([e95b72b](https://github.com/marian13/convenient_service/commit/e95b72be18e9d5d7d5126cf5c582a9df7dd5bb55))
* **service:** introduce Service#to_s ([ccd55ef](https://github.com/marian13/convenient_service/commit/ccd55efa6ee695a44ffaa8c01574ba143511fa28))
* **stub_entry:** introduce #register ([1cbe4ea](https://github.com/marian13/convenient_service/commit/1cbe4ea974bec9a0beb5e221a519533fcc577ddc))
* **stub_service:** introduce #register ([9427fe3](https://github.com/marian13/convenient_service/commit/9427fe3ed3a208f7e29d850ef92ef8be830198d9))
* **stub_service:** introduce #unregister ([042a335](https://github.com/marian13/convenient_service/commit/042a33574882b79975b2e84139032befdf3eab50))
* **stubs:** add to_return_result, to_return_value and similar ([79a4cab](https://github.com/marian13/convenient_service/commit/79a4cab394679763e57b9ae18e4b931ec356786e))
* **stubs:** add unstub_service and unstub_entry ([a55dcbe](https://github.com/marian13/convenient_service/commit/a55dcbe08483f4b3bfdfbdc5b6ce8e379ea5142c))
* **test:** load CanHaveStubbedResults by default in Minitest ([a153e62](https://github.com/marian13/convenient_service/commit/a153e625f32fe4a30c7829a81fea634c5fa7e9eb))
* **utils:** add Enumerable.find_last ([29ff27e](https://github.com/marian13/convenient_service/commit/29ff27ecbf4f36b742d1e3008bbd1bf101959789))
* **utils:** introdeuce Utils::String#tab ([814c544](https://github.com/marian13/convenient_service/commit/814c5445b6ecd7074fc291d47dc1f5e60b10da6e))

## 0.20.0 (2025-12-06)


### Features

* **amazing_print_inspect:** show original service when it is not the same as service ([5d063d3](https://github.com/marian13/convenient_service/commit/5d063d3b1a1471d3ea1803ead3574cc67513c130))
* **amazing_print:** show message as array when it contains multiple lines ([1264bb1](https://github.com/marian13/convenient_service/commit/1264bb124d35adcf33957d2ccbbe9756bbdd10e5))
* **arguments:** allow to use arguments in pattern matching ([4c24175](https://github.com/marian13/convenient_service/commit/4c24175f81d27ecddb95b373eedbd5d5f23a596c))
* **awesome_print_inspect:** show original service when it is not the same as service ([b638224](https://github.com/marian13/convenient_service/commit/b63822489f10d72f2b9d38d6fe9823abfa0269e7))
* **awesome_print:** show better backtrace when result comes from exception ([96804cd](https://github.com/marian13/convenient_service/commit/96804cd49f243ca4a1359749bcc4e6ddca4f9197))
* **awesome_print:** show message as array when it contains multiple lines ([74116e7](https://github.com/marian13/convenient_service/commit/74116e71afbb294b6db84d243d0c5f52729ba905))
* **cache:** add support of default values ([24b04a9](https://github.com/marian13/convenient_service/commit/24b04a99e0e543e5b9d5175fc229366f7c5dc70a))
* **cache:** allow to specify backend for scopes ([23ead4e](https://github.com/marian13/convenient_service/commit/23ead4e6f698db162a9cd655bbaa1842ab4f3b7a))
* **cache:** autoremove empty scopes ([c0808e1](https://github.com/marian13/convenient_service/commit/c0808e199895eef445408f3abb2e91a968c6828e))
* **cache:** introduce get/set aliases ([5630548](https://github.com/marian13/convenient_service/commit/56305485eb4d244a3e80414b173f0635d28c7f8d))
* **can_have_step_aware_enumerables:** add == to compare enumerables ([77df593](https://github.com/marian13/convenient_service/commit/77df593687c861bf9ea2b0f2971641374742e178))
* **concern:** add eval_included_block and eval_prepended_block template methods ([756a358](https://github.com/marian13/convenient_service/commit/756a3587771d3dd9204c3994ca31686e80733448))
* **config:** add a way to compare configs ([3069b7d](https://github.com/marian13/convenient_service/commit/3069b7d859b489599e7949167b601e514ba9c310))
* **config:** autodelete cache for methods without middlewares ([1238d4d](https://github.com/marian13/convenient_service/commit/1238d4d131149c854ffca95c402bbd1eb62a0605))
* **config:** introduce Config#with_defaults ([72eaf9f](https://github.com/marian13/convenient_service/commit/72eaf9f8810d9ac0ba1b6ce8205b4f5b635ce298))
* **config:** introduce UndefineMethodCallers command ([225f816](https://github.com/marian13/convenient_service/commit/225f81603ef055267b27456d25babbf0193a8017))
* **configs:** add finite_loop option ([04a63bc](https://github.com/marian13/convenient_service/commit/04a63bc3c81e1c38a9cf3dd225c96a37bd48b2af))
* **configs:** introduce active_model_attribute_assignment option ([f258f4d](https://github.com/marian13/convenient_service/commit/f258f4df71dc1095513b8bcccf711aa1828bf75d))
* **configs:** introduce active_model_attributes option ([ef32e1d](https://github.com/marian13/convenient_service/commit/ef32e1deb51bcaaf98d87cce7d5ce65b49e54970))
* **configs:** introduce active_model_validations option ([1adf917](https://github.com/marian13/convenient_service/commit/1adf91752dd1efa814a9b50c26e24551ece8dfda))
* **configs:** introduce dry_initializer option ([dac8f85](https://github.com/marian13/convenient_service/commit/dac8f8560118c3bb233f53396f7c43c3d8c50d71))
* **configs:** introduce dry_validation option ([3cff22a](https://github.com/marian13/convenient_service/commit/3cff22ad8039307a60af517657fd920a65188ad5))
* **configs:** introduce is_service/feature(_class) ([bb998d2](https://github.com/marian13/convenient_service/commit/bb998d21a1c31cf632617a0b41f98a5fef65bf79))
* **config:** support hash option ([217939d](https://github.com/marian13/convenient_service/commit/217939d7e8b67787434140e8071f2040c1fe867d))
* **convenient_service:** introduce lib_root ([6715b92](https://github.com/marian13/convenient_service/commit/6715b9276ad9d5664f6fad5b7c0bb868dba7e2a6))
* **core:** introduce ConvenientService::Core.entity? ([b725e77](https://github.com/marian13/convenient_service/commit/b725e77f8669d274b3c9f1beaa4e1cdb022f07ee))
* **core:** introduce ConvenientService::Plugins::Service::CanHaveSteps.step_class? ([7f5d730](https://github.com/marian13/convenient_service/commit/7f5d73007fc17fc713bde0057c6fef10a1e17d13))
* **data:** introduce attributes and struct methods ([1afbdd1](https://github.com/marian13/convenient_service/commit/1afbdd1f8857ffd29dfd842609b7634a569f1249))
* **data:** introduce HasMethodReaders plugin ([96252e5](https://github.com/marian13/convenient_service/commit/96252e55b494398971e39e212224caa6becde578))
* **dependencies:** allow to require dry_initializer and active_model_validations standard options ([07cfdec](https://github.com/marian13/convenient_service/commit/07cfdec2ba294f59d904301897c5078c6913e3de))
* **fallbacks:** introduce Result#with_fallback ([0677331](https://github.com/marian13/convenient_service/commit/0677331f822ab56ac23139c50a495796de814501))
* **feature:** introduce IsFeature command ([7e08928](https://github.com/marian13/convenient_service/commit/7e0892884c0be8633501ea2e34afea7d5810866f))
* **feature:** introduce IsFeatureClass command ([e9a4342](https://github.com/marian13/convenient_service/commit/e9a4342fd55499dbf6f08e838c0d018b6a2c9c69))
* **if_steps:** add initial if steps implementation ([24d7996](https://github.com/marian13/convenient_service/commit/24d7996f0be129daa007b776d31b0f9fed247665))
* **loops:** continue initial attempt ([3c05bbd](https://github.com/marian13/convenient_service/commit/3c05bbd62d770fd944a74e4590386e064d4d87f9))
* **loops:** continue initial attempt ([cc9b0d1](https://github.com/marian13/convenient_service/commit/cc9b0d1f0d9172163d94af9324eeac9c102a5d4c))
* **loops:** continue initial attempt ([29d70fd](https://github.com/marian13/convenient_service/commit/29d70fdc97e0d79464e8140b59a79f62d70fa89f))
* **loops:** continue initial attempt ([f520881](https://github.com/marian13/convenient_service/commit/f52088127096a8c6c2e19978e8b937e75ffe901d))
* **loop:** start initial attempt ([75d39c0](https://github.com/marian13/convenient_service/commit/75d39c0408dec624e9a35749265314b095df5817))
* **middlewares:** introduce naive middleware ([440ef5a](https://github.com/marian13/convenient_service/commit/440ef5afebb251e58182433e5522c2248c1405da))
* **pattern_matching:** remove status responder, introduce pattern matching support ([6934cc1](https://github.com/marian13/convenient_service/commit/6934cc1b9affc95d175208d5fb8fd64cbf2e23ba))
* **plugin:** introduce CanHaveNotPassedArguments ([2228cde](https://github.com/marian13/convenient_service/commit/2228cde6472ae05d2eb0ff9338ca13d1ebb12748))
* **plugins:** introduce .code_class? ([fb659a6](https://github.com/marian13/convenient_service/commit/fb659a68bf3d47e9ee27490b858a5da5eca4398c))
* **plugins:** introduce .data_class? ([105fda8](https://github.com/marian13/convenient_service/commit/105fda8f37dfc5fb97c714b8f27eb99e8f25bf22))
* **plugins:** introduce .message_class? ([b7275f6](https://github.com/marian13/convenient_service/commit/b7275f68f16e40cffd31818839f0fc367f87c16b))
* **plugins:** introduce .result_class? ([171d045](https://github.com/marian13/convenient_service/commit/171d0456ecd612df6e45adc6907edd3ba6427537))
* **plugins:** introduce .status_class? ([be13f7e](https://github.com/marian13/convenient_service/commit/be13f7ea464767ab06edf4103bfb700592a33e9b))
* **plugins:** introduce CleansExceptionBacktrace ([89908e4](https://github.com/marian13/convenient_service/commit/89908e47f091b3a5350cc82cb43e1c65a1fb25d6))
* **plugins:** introduce HasMemoization::UsingMemoWise ([1ed2189](https://github.com/marian13/convenient_service/commit/1ed2189b7bbae74428965b4745806388e172ebc1))
* **queries:** introduce Dependencies.ruby.match? ([d411595](https://github.com/marian13/convenient_service/commit/d4115953edfac43e20417064ecc15d05ee6b70a3))
* **reassignment:** allow to reassign private methods ([d89e5ec](https://github.com/marian13/convenient_service/commit/d89e5ec7dccdecf884da618e2cf239e1b73fdcd5))
* **require:** expose extras in idiomatic way ([9e9ff70](https://github.com/marian13/convenient_service/commit/9e9ff70ec5ef2183d7c7a9ef2c3fa980e9f9480a))
* **result_matchers:** add optional index to of_step chaining ([6af4901](https://github.com/marian13/convenient_service/commit/6af4901598be0f37f30b40140c0bbcdfaeb735c8))
* **result:** introduce Result#call ([34e6ed9](https://github.com/marian13/convenient_service/commit/34e6ed9562743390943579f03c662aef7085b58a))
* **result:** introduce Result#strict ([23fabda](https://github.com/marian13/convenient_service/commit/23fabda2a605e63e64c0001e41ab770c499fe28a))
* **rspec:** allow to match class aliases by have_alias_method ([f18b840](https://github.com/marian13/convenient_service/commit/f18b840a51e37e98d224eed4d347a365cd88f99c))
* **rspec:** introduce include_config matcher ([4758e7a](https://github.com/marian13/convenient_service/commit/4758e7a7d745398fe5dcefdcd1cc7cbdded09355))
* **rspec:** introduce initial implementation of include_in_order ([3a68ef5](https://github.com/marian13/convenient_service/commit/3a68ef504d10d1f889302e2a55d8e3bf0d16efaf))
* **service:** introduce Service#call ([8cd69fb](https://github.com/marian13/convenient_service/commit/8cd69fb9b1af3e05c9f1b51e1dac61a9fd33eb58))
* **stack:** add append alias for use ([54fad07](https://github.com/marian13/convenient_service/commit/54fad07942a39e2bcdc5455a9d2b62ff406af70d))
* **step_params:** introduce #to_callback_arguments ([5fd871a](https://github.com/marian13/convenient_service/commit/5fd871a0679026471f2fb28994bfe5bb3d7ce8cc))
* **step:** allow to use raw and proc value as step outputs ([bc945b9](https://github.com/marian13/convenient_service/commit/bc945b93f71bf46d980903fbaa1782f8034c450f))
* **step:** introduce strict steps (strict step converts failure to error) ([40778c3](https://github.com/marian13/convenient_service/commit/40778c335764e4ea5b9e0d5f394245b8dda47141))
* **steps:** allow to skip hash curly brackets for inputs and outputs ([f81cd57](https://github.com/marian13/convenient_service/commit/f81cd57419417ae5673b7b4209d7eb1645b1000a))
* **support:** allow Copiable#copy to replace kwargs ([d149fd8](https://github.com/marian13/convenient_service/commit/d149fd8113ec1c3a8dc5a456709fb6e83fd6b2be))
* **utils:** add safe_send shortcut ([a044cd7](https://github.com/marian13/convenient_service/commit/a044cd7f0506b937dadb78252e7f5895c0778d65))
* **utils:** introduce GetNamespace util ([0f127b6](https://github.com/marian13/convenient_service/commit/0f127b6f37f03aeef99d42c5211e388a6c8aa427))
* **utils:** introduce Method::Name.append ([8a26736](https://github.com/marian13/convenient_service/commit/8a267367a05c82e6043fa91f4b9e62ef762c37f0))
* **utils:** introduce Method.remove ([7289c51](https://github.com/marian13/convenient_service/commit/7289c5156f67b04540f63d44ec2ae576893cffb5))
* **utils:** introduce with_one_time_object ([bd0d389](https://github.com/marian13/convenient_service/commit/bd0d389db19e7ea373e7b8be961ac00333476579))


### Bug Fixes

* **cache:** do not store accidentally scoped keys ([7865c12](https://github.com/marian13/convenient_service/commit/7865c12e696faee3bb3cdeb63f980a19f7d390aa))
* **callbacks:** rerun callbacks every time result is recalculated ([5b1e16e](https://github.com/marian13/convenient_service/commit/5b1e16eef8c463ba599afaf2f099d060a905e550))
* **delegate_to:** add hack for JRuby to call delegation value ([e589300](https://github.com/marian13/convenient_service/commit/e58930092e501c8fba5f8812d26c9d33ca121879))
* **fallbacks:** update fallback_result? to return true only when result comes from fallback_result ([df3ad87](https://github.com/marian13/convenient_service/commit/df3ad87584c2d6745723506f646cf16fca40da57))
* **hash:** handle collisions properly ([f7fc1e7](https://github.com/marian13/convenient_service/commit/f7fc1e71eb8c2ecbf4783ca6840efb80a07eee6f))
* **matchers:** add hack for JRuby to match aliases created from attr_reader methods ([081f628](https://github.com/marian13/convenient_service/commit/081f628c92447de39dd463186424bc49a4c467da))
* **result_spec:** do not cache intermediate values since they can be changed multiple times ([b6b3036](https://github.com/marian13/convenient_service/commit/b6b303687e6fe0ab8f7ea2865758cf82ee684b0a))
* **rspec:** set used_step_index when nil is passed as index ([a49db71](https://github.com/marian13/convenient_service/commit/a49db71ab9955e28774b662f4e931ec0c7227059))
* **ruby_middleware:** do not load pp ([80a75ba](https://github.com/marian13/convenient_service/commit/80a75babc5b5612e898f6191611379522260372a))
* **step_params:** exclude strict from extra kwargs ([6d0500d](https://github.com/marian13/convenient_service/commit/6d0500d0011b4399915c5be3aa10ec6039e24d4e))
* **stub_entry:** match only argument-less call by without_arguments ([0c402c9](https://github.com/marian13/convenient_service/commit/0c402c9efdd3229d96e6865ff11cc14184289a93))
* **stub_service:** match only aargument-less call by without_arguments ([4f7774f](https://github.com/marian13/convenient_service/commit/4f7774f1a43f40329a4d88c9aca394464cd3afd1))


### Performance Improvements

* **stubs:** use thread safe array only for arguments ([f7c7b93](https://github.com/marian13/convenient_service/commit/f7c7b9347c0581ee8f589cc9a37c93df7630ac0f))


### Miscellaneous Chores

* release 0.20.0 ([7c6f23c](https://github.com/marian13/convenient_service/commit/7c6f23c16e83efd7ab2b05b216e9055f411dcdee))

## [0.20.0](https://github.com/marian13/convenient_service/compare/v0.19.0...v0.20.0) (2024-07-27)


### ⚠ BREAKING CHANGES

* **steps:** remove reassignments since out already supports them without keyword
* **dependencies:** add suffix for configs and plugins require
* **configs:** introduce FaultTolerance config, make available by default, without require

### Features

* **config:** introduce CodeReviewAutomation config ([1c142d7](https://github.com/marian13/convenient_service/commit/1c142d7f8f5f491749f633b0404fa63086a8b76d))
* **config:** introduce ExceptionServicesTrace config ([2d030ea](https://github.com/marian13/convenient_service/commit/2d030eab3a1bd40574f977e8c48d71fea2935682))
* **config:** introduce initial Config module ([4b9715d](https://github.com/marian13/convenient_service/commit/4b9715d315e3c5abc26a10eb75dea41a74e0b9a9))
* **config:** introduce PerInstanceCaching config ([86ce8c3](https://github.com/marian13/convenient_service/commit/86ce8c3a44c53b060ab2b10a892ac35f4b2b2e32))
* **config:** introduce Recalculation config ([cf27622](https://github.com/marian13/convenient_service/commit/cf276227af7a925e3b85c15e21d20ce196d16ebe))
* **config:** introduce ResultParentsTrace config ([cc611b6](https://github.com/marian13/convenient_service/commit/cc611b6f79ccff9ab03c218b038e79ec1fc7eb05))
* **config:** introduce Rollbacks config ([e2a5d30](https://github.com/marian13/convenient_service/commit/e2a5d30577aa3c3845e58d814609d8e89ffea451))
* **config:** introduce TypeSafety config ([3ce6de2](https://github.com/marian13/convenient_service/commit/3ce6de27b959f43592e5514ed58aff40be018c9c))
* **core:** allow to call original method that skips middlewares ([c177c7b](https://github.com/marian13/convenient_service/commit/c177c7b21d118ee86733c1c228aa871b9ecd8b90))
* **service:** introduce CanNotBeInherited optional plugin ([5170013](https://github.com/marian13/convenient_service/commit/5170013328ab456e49274e68cc141bc4df891212))
* **arguments:** introduce Arguments#[] ([c5a580f](https://github.com/marian13/convenient_service/commit/c5a580f432392c67d17404d472bf951fcfccb175))
* **callbacks:** introduce Service.callback that is called by before, after, and around ([38280a4](https://github.com/marian13/convenient_service/commit/38280a47668991decba2878306fe57d1988ae3a2))
* **can_be_method_step:** allow to create middlewares specifically for method step result ([15b2d24](https://github.com/marian13/convenient_service/commit/15b2d24937158a22ebd1091ddaf2e9dce216ab5b))
* **can_have_connected_steps:** allow to create middlewares for specifically for steps result, but not regular result ([894cb36](https://github.com/marian13/convenient_service/commit/894cb36ec1e80da504aac26373d99250202f2373))
* **can_have_connected_steps:** extract regular_result method ([c2113ad](https://github.com/marian13/convenient_service/commit/c2113ad41e800d6984f9c642303745d15c4675a3))
* **code:** add custom code to results from RescuesResultUnhandledExceptions, HasJSendResultParamsValidations::UsingActiveModelValidations and HasJSendResultParamsValidations::UsingDryValidation ([28797fd](https://github.com/marian13/convenient_service/commit/28797fd5d7f98a52d4d86350e04502fda0c41aae))
* **configs:** extract Inspect config ([dce5037](https://github.com/marian13/convenient_service/commit/dce5037e463a72fde5c427158b19dd3e05af3007))
* **configs:** introduce FaultTolerance config, make available by default, without require ([dbe3cb7](https://github.com/marian13/convenient_service/commit/dbe3cb7ad2f58ba3ca263216cef33b7fe2c33938))
* **middleware:** introduce new middleware backend ([6d6dead](https://github.com/marian13/convenient_service/commit/6d6dead3fad4e90a242d5e998ad2a367cdcf85ab))
* **result:** introduce Result#exception, move correspponding plugin to FaultTolerance config ([476a006](https://github.com/marian13/convenient_service/commit/476a00617506a3135f54c40dca3cc285d21d1424))
* **step_callbacks:** pass step args, kwargs to callback ([82c7712](https://github.com/marian13/convenient_service/commit/82c7712ef03b4f0253be073c79d25e5cd86a3a97))
* **steps:** add callbacks for Step#result ([91b22f5](https://github.com/marian13/convenient_service/commit/91b22f5d61fc72afda6a368eaf763d214983f34f))


### Bug Fixes

* **callbacks:** show source_location in exception joined by colon ([9a66f7f](https://github.com/marian13/convenient_service/commit/9a66f7fd4cd86920e5918ab300038eb3b674b6d1))
* **callbacks:** trigger before step caallback before step result is calculated ([3ea9964](https://github.com/marian13/convenient_service/commit/3ea996485045ea19682b153a5316f89358e25e2e))
* **connected_steps:** do not evaluate right expression when left expression is success ([19e4d5d](https://github.com/marian13/convenient_service/commit/19e4d5d1f5feda2fd23ef8e715d0d06b219336b5))


### Performance Improvements

* **regular_result:** use result_without_midlewares instead of own method lookup ([e0e6b60](https://github.com/marian13/convenient_service/commit/e0e6b604a570cf04e10b31bde547739a0e5f26de))


### Miscellaneous Chores

* release 0.20.0 ([ecd377e](https://github.com/marian13/convenient_service/commit/ecd377ee1a90215b1f90e8caa10aa0259f081097))


### Code Refactoring

* **dependencies:** add suffix for configs and plugins require ([f81a8a9](https://github.com/marian13/convenient_service/commit/f81a8a96d7a08b17472a2590e61ae245b48ec209))
* **steps:** remove reassignments since out already supports them without keyword ([0374519](https://github.com/marian13/convenient_service/commit/03745193ce103d26cdbcd4f5d927d4d9ba3182ca))

## [0.19.1](https://github.com/marian13/convenient_service/compare/v0.19.0...v0.19.1) (2024-07-27)

### Bug Fixes

* **connected_steps:** do not evaluate right expression when left expression is error ([3e3998d](https://github.com/marian13/convenient_service/commit/3e3998df90fe671567276a9119d762567641ecec))

## [0.19.0](https://github.com/marian13/convenient_service/compare/v0.18.0...v0.19.0) (2024-06-08)


### Features

* **can_have_steps:** introduce StepCollection#size ([6360e2e](https://github.com/marian13/convenient_service/commit/6360e2ea7acc5653723be1bea03cdf81b9b0ea1c))
* **configs:** introduce AmazingPrintInspect config ([3035523](https://github.com/marian13/convenient_service/commit/303552349b6890971a16f4ad91d1a672bf67cc13))
* **docker:** add Ruby 3.4.0-preview1 ([a115459](https://github.com/marian13/convenient_service/commit/a115459b42f8e4580950b0b0ab1dba27b3c23271))
* **fallback:** introduce fallback_result that is called for both failure and error, but has lower priority when specific method is defined ([498bde0](https://github.com/marian13/convenient_service/commit/498bde0a3215869c5c3184cb4177aac2e3c7c13c))
* **fallbacks:** do not allow fallbacks for method steps ([f90abdd](https://github.com/marian13/convenient_service/commit/f90abddbaabbc340b9273a9c39da9b1ad3a68c5b))
* **middleware_stack:** introduce alias #prepend for #unshift, #remove for #delete ([527bb34](https://github.com/marian13/convenient_service/commit/527bb342e290a3c925bceb8500bc6c133fb6c3b5))
* **plugins:** introduce ForbidsConvenientServiceEntitiesAsConstructorArguments ([088505d](https://github.com/marian13/convenient_service/commit/088505db8ab01dda5814d92756a4c3dbc6a0d07d))
* **result:** introduce Result#from_exception? ([a47838a](https://github.com/marian13/convenient_service/commit/a47838a47a5db998e045c6d9ac2ff90fb77c6818))
* **result:** introduce Result#from_step? ([66cdf2a](https://github.com/marian13/convenient_service/commit/66cdf2a817b86312c4542a8904a3f256ba751831))
* **rollback:** introduce initial version of HasRollbacks ([306960d](https://github.com/marian13/convenient_service/commit/306960d075a7d62a2e4c0db2dc5bcf03f7d7b514))
* **service:** introduce ConvenientService::Service::Plugins::CanHaveSteps.step? ([340d327](https://github.com/marian13/convenient_service/commit/340d32724bd16d44a2a55389b50953c8c19eaedd))
* **service:** introduce ConvenientService.service? and ConvenientService.service_class? ([c4caf14](https://github.com/marian13/convenient_service/commit/c4caf144affdea74fb32728ca9377eb7ff7f0aea))
* **step:** cache Step#service_result ([2fd0cd9](https://github.com/marian13/convenient_service/commit/2fd0cd97ffdd4cbb3c3aee1e6c6ad71510780824))
* **step:** introduce Step#printable_container ([9a555bd](https://github.com/marian13/convenient_service/commit/9a555bd276e6eb903dccf340e145687540d3ab16))
* **support:** introduce Ruby#mri? ([a336874](https://github.com/marian13/convenient_service/commit/a336874532e0a5e06e6721068876efeff9278bb1))
* **utils:** introduce Object.own_method ([39e3c08](https://github.com/marian13/convenient_service/commit/39e3c0861fe33fb3c866280999cd726674a46c24))
* **utils:** introduce Object.safe_send ([c66a551](https://github.com/marian13/convenient_service/commit/c66a5517e55f2a718472612be112d88f71178204))
* **utils:** introduce String.enclose ([10971c5](https://github.com/marian13/convenient_service/commit/10971c5e7cf329ab926ea8271aa3b5d1bcab9fa8))
* **utils:** rescue all standard error exceptions from Object.safe_send ([2470a62](https://github.com/marian13/convenient_service/commit/2470a626f69b400b05280a78869c5248a4c404fc))


### Bug Fixes

* **awesome/amazing_print:** use message key as nested ([86e41bf](https://github.com/marian13/convenient_service/commit/86e41bf57ea4fdefc8f6cceca47f208374c09b76))
* **BACKLOG:** remove typo ([3fcae2b](https://github.com/marian13/convenient_service/commit/3fcae2bb33c16ad66708df739da1b411237eebc5))
* **can_have_connected_steps:** do not evaluate right expression when it can be avoided ([131f911](https://github.com/marian13/convenient_service/commit/131f911bc3a32784e1bb2cd28ffc7a02ca75c5f7))
* **can_have_connected_steps:** use ConvenientService.raise ([a19ce55](https://github.com/marian13/convenient_service/commit/a19ce55dffe870abd3500d58520663a716cec56e))
* **can_have_fallbacks:** use ConvenientService.raise ([148317d](https://github.com/marian13/convenient_service/commit/148317df2d9973692ff2d60b404021c72c3c8cab))
* **forbids_convenient_service_entities_as_constructor_arguments:** use ConvenientService.raise ([1e5a260](https://github.com/marian13/convenient_service/commit/1e5a2600f723a8356f7c067d8db2d88585c0245a))
* **forbids_convenient_service_entities_as_constructor_arguments:** use ConvenientService.raise ([ca89de8](https://github.com/marian13/convenient_service/commit/ca89de850fca336408b7c4dc90a271d196687a56))
* **ruby_engine_version:** remove wrong memoization ([addbd54](https://github.com/marian13/convenient_service/commit/addbd545df02011fd3c140024b699db60645d81a))
* **step:** respect aliases for last(all) steps ([b8285e3](https://github.com/marian13/convenient_service/commit/b8285e33c764a61bd8fa1df6e126e45c4491a5a6))
* **Taskfile:** remove typo ([a577fbd](https://github.com/marian13/convenient_service/commit/a577fbd5a5949fa11963b024e76fe6dab1ce509c))


### Performance Improvements

* **method_middleware:** inline env normalization ([2dfe210](https://github.com/marian13/convenient_service/commit/2dfe2104834cce1fd0bfbfc9dd5436f78d54beee))


### Miscellaneous Chores

* release 0.19.0 ([4df0c8b](https://github.com/marian13/convenient_service/commit/4df0c8b8d80dabf14419594b8630cd3c469ae75b))

## [0.18.0](https://github.com/marian13/convenient_service/compare/v0.17.0...v0.18.0) (2024-03-07)


### ⚠ BREAKING CHANGES

* **can_have_steps:** make step not fully compatible with result since it is an independent entity

### Features

* **backtrace_cleaner:** do not clean specs ([11f8f0c](https://github.com/marian13/convenient_service/commit/11f8f0cf33bcf08f1c76b9dedeeeabe934a6efad))
* **can_be_negated:** introduce Result#negated? ([1362b9b](https://github.com/marian13/convenient_service/commit/1362b9be2bd3a32963b6c02303a146c055a90c9c))
* **can_connected_steps:** add inspect ([d1318bd](https://github.com/marian13/convenient_service/commit/d1318bd6981b95c819fa7c162047c804086e4969))
* **can_connected_steps:** introduce group, not_group, and_group, and_not_group, or_group, or_not_group ([c517ef5](https://github.com/marian13/convenient_service/commit/c517ef5f4ee73e3572120810bb5e8766f19a9cfa))
* **can_have_connected_steps:** add inspect for empty expression ([40496c1](https://github.com/marian13/convenient_service/commit/40496c135012c643f724d1b05bfb36bfd8cc1c19))
* **can_have_connected_steps:** add StepCollection#inspect ([0523136](https://github.com/marian13/convenient_service/commit/052313621175f8b910b993e2621021641853a466))
* **can_have_connected_steps:** define exceptions ([f481b33](https://github.com/marian13/convenient_service/commit/f481b33636d61c6c74759e5bcdc409d46a2eeb07))
* **can_have_connected_steps:** introduce #scalar? ([6ff4b38](https://github.com/marian13/convenient_service/commit/6ff4b38e10fb73b81d8f294704c350551c4006df))
* **can_have_connected_steps:** introduce and expression ([c654351](https://github.com/marian13/convenient_service/commit/c654351f6c37c8bc3e83816d5aff8cf7362c9ed7))
* **can_have_connected_steps:** introduce base expression ([d5243a3](https://github.com/marian13/convenient_service/commit/d5243a369563123b79cee21fe93acd70d86951db))
* **can_have_connected_steps:** introduce empty expression ([222c053](https://github.com/marian13/convenient_service/commit/222c053d8741c01fbf093807b39dbcec4e5dfb75))
* **can_have_connected_steps:** introduce expression#steps ([7644a44](https://github.com/marian13/convenient_service/commit/7644a44d3116b631beb49cfd2a2e1a72b921efdc))
* **can_have_connected_steps:** introduce group expression ([7f0ceff](https://github.com/marian13/convenient_service/commit/7f0ceff9f8b1fdb7c3b62581f35934f6654c0b92))
* **can_have_connected_steps:** introduce middleware ([4d5f409](https://github.com/marian13/convenient_service/commit/4d5f409ada210025c353e9e8c01bf1792649501e))
* **can_have_connected_steps:** introduce not expression ([583ddc4](https://github.com/marian13/convenient_service/commit/583ddc4f1049b2d7fd27b8d11354f40f2df033b3))
* **can_have_connected_steps:** introduce not_step ([1336cb1](https://github.com/marian13/convenient_service/commit/1336cb1b128cfa764cc1d9c024a5fa7aadb8270f))
* **can_have_connected_steps:** introduce or expression ([b4d72a5](https://github.com/marian13/convenient_service/commit/b4d72a5d5d4b7d62ba91df73fbfd55e086c3de10))
* **can_have_connected_steps:** introduce scaalar ([20bee82](https://github.com/marian13/convenient_service/commit/20bee824e72e6f193e8d1d74e3f7c52b05d95c82))
* **can_have_connected_steps:** start to use can_have_connected_steps by default ([16fb5e2](https://github.com/marian13/convenient_service/commit/16fb5e247f1bcda1d0eb59b047041914c5863254))
* **can_have_negated_steps:** introduce and_step, not_step, and_not_step ([fab351c](https://github.com/marian13/convenient_service/commit/fab351c93b8c113012470bccd49b60b0d3386d6b))
* **can_have_sequential_steps:** add StepCollection#inspect ([8ba096f](https://github.com/marian13/convenient_service/commit/8ba096f6a269cd1a1c55d1f8f843ba6fe6f2b941))
* **can_have_steps:** allow to override inputs in method steps ([9d5e129](https://github.com/marian13/convenient_service/commit/9d5e1292dbaef933e4616501fe0994fa565bd0a0))
* **delegate_to:** add failure message for and_return ([eebfcb4](https://github.com/marian13/convenient_service/commit/eebfcb43df970f8c9c653f82061441770e7608c7))
* **delegate_to:** introduce not reaady for public usage and_return { ... } ([30b1757](https://github.com/marian13/convenient_service/commit/30b17573e8ca3d69b1f0caf1450d9b01d1d2b268))
* **has_have_steps:** introduce Step#to_s ([19b1958](https://github.com/marian13/convenient_service/commit/19b1958f30fde8af9e246de04f9c779d39b3df17))
* **has_j_send_result:** raise exception when to_bool called on error ([5cfcefa](https://github.com/marian13/convenient_service/commit/5cfcefa8d93c360fda39b5137b27d3d9beda8cd8))
* **has_j_send_status_and_attributes:** introduce #to_bool, #to_object, #to_a, #to_h, #to_s for learning purposes ([a3c1782](https://github.com/marian13/convenient_service/commit/a3c1782c3e4d09475a1fa980ae37c83b6864e1e9))
* **has_negated_result:** introduce #negated_result ([6890cef](https://github.com/marian13/convenient_service/commit/6890ceff47a082f5dee389ce65420275265929f5))
* **has_negated_result:** introduce initial HasNegatedResult plugin ([8c8fd70](https://github.com/marian13/convenient_service/commit/8c8fd706ce06a1099d4837e8427a8d4b1c6340c3))
* **has_negated_result:** use HasNegatedResult plugin ([6cb4e48](https://github.com/marian13/convenient_service/commit/6cb4e484d0010560b2d78fe1a6431873d401d251))
* **has_result_steps:** introduce unsafe nott statuses ([fe845b0](https://github.com/marian13/convenient_service/commit/fe845b07d72d7b4f6d7826853688f508519c660d))
* **internals:** add cache to class ([b1363c7](https://github.com/marian13/convenient_service/commit/b1363c78f25354458c0a32e5fe5445e5f6e8f3ad))
* **support:** introduce never reach here ([c974f6b](https://github.com/marian13/convenient_service/commit/c974f6b746c5ef6499eb43d1be04084530918846))
* **support:** introduce value ([987455b](https://github.com/marian13/convenient_service/commit/987455b1e85932fd11ac23e6d682b1d27b1a6f9d))
* **utils:** allow to pass custom enumerablesto .find_last ([85892da](https://github.com/marian13/convenient_service/commit/85892da96624a8b5c586c6e361f985f62de8ba78))


### Bug Fixes

* **can_have_sequential_steps:** do not rely on automation plugin inside essential plugin ([d9fe475](https://github.com/marian13/convenient_service/commit/d9fe475ed0efd5b44a957a26fa3ead76775b6f57))
* **can_have_steps:** use extra kwargs while comparing steps ([82fb2b6](https://github.com/marian13/convenient_service/commit/82fb2b6bd43e60dafce94aa8b9dc8da27f8a5395))
* **gemspec:** use README.md ([299e1cd](https://github.com/marian13/convenient_service/commit/299e1cdb9d8061dc86f87ee9e26a4b2b633701ab))
* **can_have_callbacks:** state explicitly that callbacks for class methods are not supported yet ([5f03829](https://github.com/marian13/convenient_service/commit/5f038291fda6ce251d69b03dd2b9e948710fe5bd))
* **has_instance_proxy:** reraise rescued exception ([fc3f8ee](https://github.com/marian13/convenient_service/commit/fc3f8ee64e826eb145dd01a8c38044631c830eca))
* **has_jsend_result:** remove outdated exception ([a92fa15](https://github.com/marian13/convenient_service/commit/a92fa159037982d37bdae89144c4471674439c7e))
* **has_negated_result:** use copy to not lose original result extra kwargs ([80d5f10](https://github.com/marian13/convenient_service/commit/80d5f10d32c5fbab959004e848c9dd77b4c52cc2))
* **has_negated_result:** use HasNegatedResult only for Standard config, not for minimal or v1 ([b28453c](https://github.com/marian13/convenient_service/commit/b28453ca31de04cd203b7f01eac252ff4ca5b5d6))
* **support:** compare value by hash in eql? ([a68ee68](https://github.com/marian13/convenient_service/commit/a68ee683cbf043edb3bfa64649d72ed241b933ba))
* **vscode:** bring back cache_its_value ([e73ad88](https://github.com/marian13/convenient_service/commit/e73ad88ab224a1d9f566af4d15f385e5d4ae3214))


### Miscellaneous Chores

* release 0.18.0 ([343176f](https://github.com/marian13/convenient_service/commit/343176fc9b530edde2a134824a72cb1e15b45d4b))


### Code Refactoring

* **can_have_steps:** make step not fully compatible with result since it is an independent entity ([5cea95d](https://github.com/marian13/convenient_service/commit/5cea95db9caed37d5d06a28b1202d96de513c3ec))

## [0.17.0](https://github.com/marian13/convenient_service/compare/v0.16.0...v0.17.0) (2024-01-14)


### Features

* **backtrace_cleaner:** introduce add_convenient_service_silencer ([07ce10f](https://github.com/marian13/convenient_service/commit/07ce10fbd96c7e6b3074922d0ca8af6547416725))
* **backtrace_cleaner:** upgrade to Rails 7.1.2 Backtrace Cleaner ([6416691](https://github.com/marian13/convenient_service/commit/6416691d99d3b22544b78ea81aed5a3a4aa513fe))
* **core:** clean backtrace in method_missing ([0642198](https://github.com/marian13/convenient_service/commit/06421981ccf39d2d0b07f2bce30284c604bba950))
* **core:** clean backtrace in method_missing ([81d0531](https://github.com/marian13/convenient_service/commit/81d05317d842d9afa2ef7034b34b850034a8f1dd))
* **core:** clean backtrace in method_missing ([f07c354](https://github.com/marian13/convenient_service/commit/f07c354e8fc14f1062df68f938b9d4b9fa8484c5))
* **entry:** allow to define multiple entries at once ([a9bca88](https://github.com/marian13/convenient_service/commit/a9bca880da4849866f6afc30b3f099be88834f64))
* **exception:** allow to pass message or kwargs or no arguments ([a92a040](https://github.com/marian13/convenient_service/commit/a92a04002687c878618479804d0176e69b3d4fa4))
* **exceptions:** use backtrace_cleaner ([7bc566e](https://github.com/marian13/convenient_service/commit/7bc566e78cfa3fcc28b6b2318ca955ff4d797ce8))
* **exceptions:** use backtrace_cleaner ([b8d87a5](https://github.com/marian13/convenient_service/commit/b8d87a56cb4afda043ba0de6c1ba3cd967d2aa7c))
* **feature:** allow to use middlewares for all entries at once ([a2025dc](https://github.com/marian13/convenient_service/commit/a2025dccbf660cdc313f9db7df155ccd7a4cd3b8))
* **has_instance_proxy:** delegate to target missing proxy methods ([6be8d3b](https://github.com/marian13/convenient_service/commit/6be8d3b6bf556bc2af9ff29a7b0782b352a8effb))
* **has_instance_proxy:** introduce #inspect ([078d219](https://github.com/marian13/convenient_service/commit/078d21927b1b523b266e85d945f87aa3030de0f4))
* **has_j_send_result:** expose result? ([f4d5f7f](https://github.com/marian13/convenient_service/commit/f4d5f7fb9afde955295602db022d12f084f60d9e))
* **has_j_send_status_and_attributes:** introduce #to_bool ([ec5ee1e](https://github.com/marian13/convenient_service/commit/ec5ee1ec0f4a540a109f80e3ffafa1b937d1af60))
* **root:** introduce ConvenientService.raise and ConvenientService.reraise ([65f0148](https://github.com/marian13/convenient_service/commit/65f0148d052c31c3e305470b2b9daee5c746794e))
* **root:** introduce ConvenientService.root ([dc5af36](https://github.com/marian13/convenient_service/commit/dc5af365374a76d615fa09613b59bb9cd080bc1b))
* **support:** add initial backtrace cleaner ([14733f3](https://github.com/marian13/convenient_service/commit/14733f3d5b622c08aec1fe0b80a2b7c5699b4d4f))


### Bug Fixes

* **backtrace_cleaner:** resolve JRuby incompatibilites ([3ff9055](https://github.com/marian13/convenient_service/commit/3ff90555a0f78f1ba51fa7c538cc84c7c4e69bdb))
* **rescues_result_unhandled_exceptions:** fix false-positive test ([e792c01](https://github.com/marian13/convenient_service/commit/e792c01613a74da529f2f7833248527c40f1ac7b))
* **specs:** remove did_you_mean flakiness ([709faf6](https://github.com/marian13/convenient_service/commit/709faf6c8ac9eb28451f3ea734d5588159481648))

## [0.16.0](https://github.com/marian13/convenient_service/compare/v0.15.0...v0.16.0) (2023-12-05)


### Features

* **entry:** allow to use instance method, just like field in graphql-ruby ([ad445fa](https://github.com/marian13/convenient_service/commit/ad445fae5ace9671745b2cacd2f6fae7b5a0e26e))

## [0.15.0](https://github.com/marian13/convenient_service/compare/v0.14.0...v0.15.0) (2023-11-10)


### ⚠ BREAKING CHANGES

* **feature:** allow to use plugins for features

### Features

* **can_have_steps:** do not allow to modify steps from callbacks ([b90b7f7](https://github.com/marian13/convenient_service/commit/b90b7f7b5ba7b9cb12151d02495d1ad1c230504e))
* **feature:** allow to use plugins for features ([17645f8](https://github.com/marian13/convenient_service/commit/17645f888849b5cb42c2ae45aa8430cb96e28eff))


### Bug Fixes

* **can_have_steps:** introduce raises_on_not_result_return_value for steps ([bb27527](https://github.com/marian13/convenient_service/commit/bb27527b708747df356980cf831c660757fb4093))


### Miscellaneous Chores

* release 0.15.0 ([7f6a6a7](https://github.com/marian13/convenient_service/commit/7f6a6a74b722eaf26ae7195351a9078c944032dd))

## [0.14.0](https://github.com/marian13/convenient_service/compare/v0.13.0...v0.14.0) (2023-09-20)


### ⚠ BREAKING CHANGES

* **has_j_send_result_params_validations:** return errors on validation issues
* **has_j_send_result_params_validations:** return errors on validation issues
* **can_have_fallbacks:** fallback only failures by default
* **be_result:** update got part
* **has_j_send_result_short:** update constants
* **fallbacks:** create separate fallbacks failures and errors, run only error fallback when true

### Features

* **be_result:** introduce be_result ([f8fc85b](https://github.com/marian13/convenient_service/commit/f8fc85bb9141851c130a040731e4bb99114050d2))
* **can_have_fallbacks:** allow to pass fallback_true_status ([584dabe](https://github.com/marian13/convenient_service/commit/584dabe83f87c2d794ea779a3e5c7f0b0ea97f65))
* **can_have_fallbacks:** fallback only failures by default ([58650a7](https://github.com/marian13/convenient_service/commit/58650a736be0a4daaf283c6eef9e0867a34d44d4))
* **configs:** create copy of v1 ([bb039c8](https://github.com/marian13/convenient_service/commit/bb039c83f53607c4cf59f634c662fc604f13ff7b))
* **examples:** create copy of v1 ([70bd3fe](https://github.com/marian13/convenient_service/commit/70bd3febc4a88ebe7e7c3d33c7dd2e1c03331ccb))
* **has_awesome_print_inspect:** add message and data keys ([14e0a3f](https://github.com/marian13/convenient_service/commit/14e0a3f088edf8ea8565ba7ff06ca0212c4116e9))
* **has_inspect:** add message and data keys ([8f30b7a](https://github.com/marian13/convenient_service/commit/8f30b7a905b8a953d514061ed381a404b65c81af))
* **has_j_send_result_params_validations:** return errors on validation issues ([e25e1a4](https://github.com/marian13/convenient_service/commit/e25e1a4f94cc309035533220dbcfbfccbb94cc94))
* **has_j_send_result_params_validations:** return errors on validation issues ([09a9b94](https://github.com/marian13/convenient_service/commit/09a9b948070f3132818d1da9ef009d1d15655ab9))
* **has_j_send_result_short_syntax:** allow to pass data, message, code to all results ([aabf2f9](https://github.com/marian13/convenient_service/commit/aabf2f98d32407616159cbcd2bcc6349a9a3b98f))
* **has_j_send_result_short_syntax:** allow to pass message and code to short form of error ([1af3153](https://github.com/marian13/convenient_service/commit/1af3153aa1bf385eadcf73f30e13a3cc5126d793))
* **has_j_send_result_short_syntax:** allow to pass message and code to short form of failure ([7390630](https://github.com/marian13/convenient_service/commit/73906300f94ec6488f312d4a611f433d8c850691))
* **has_j_send_result_short_syntax:** allow to pass message and code to short form of success ([fdf2ab2](https://github.com/marian13/convenient_service/commit/fdf2ab23ade8941ed2c6dd10d17769eaebecc855))
* **has_j_send_status_and_attributes:** introduce Data#keys ([27f43e1](https://github.com/marian13/convenient_service/commit/27f43e1594988cc523e9bb3608e90a40e4c2b442))
* **has_j_send_status_and_attributes:** introduce Message#empty? ([6c1452d](https://github.com/marian13/convenient_service/commit/6c1452d99d71be45bb6cb95159a2fd32ffca668e))
* **rescues_result_unhandled_exceptions:** allow to pass status ([2ef85f2](https://github.com/marian13/convenient_service/commit/2ef85f2970dd56802bd22f467529da6242faf967))
* **using_active_model_validations:** allow to pass status to middleware ([bc5bb70](https://github.com/marian13/convenient_service/commit/bc5bb7027fe94724a8d28a3770b68c731b37ff10))
* **using_dry_validation:** allow to pass status to middleware ([3a5ef12](https://github.com/marian13/convenient_service/commit/3a5ef120219a8a94b1d15bb7226f265db967ce9e))


### Miscellaneous Chores

* release 0.14.0 ([c7cef07](https://github.com/marian13/convenient_service/commit/c7cef0721d8360329c19b8ad4d636bcec83805c6))


### Code Refactoring

* **be_result:** update got part ([428280a](https://github.com/marian13/convenient_service/commit/428280a8eb2aed09f49bd949f84b7e10ef933708))
* **fallbacks:** create separate fallbacks failures and errors, run only error fallback when true ([bbab564](https://github.com/marian13/convenient_service/commit/bbab5647d09ecdba9c9727bef3e2dc6b8138710b))
* **has_j_send_result_short:** update constants ([2074acd](https://github.com/marian13/convenient_service/commit/2074acd001115dd4c60d432e71a4fef58794c881))

## 0.13.0 (2023-08-27)


### ⚠ BREAKING CHANGES

* **has_j_send_result:** rename HasResult to HasJSendResult
* **has_result_short_syntax:** allow to pass message to failures
* **core:** disallow config commitment by missing private method
* **can_have_stubbed_result:** state explicitly cache backend
* **has_j_send_status_and_attributes:** use Jsend to JSend

### Features

* **alias:** introduce CS alias ([14652d7](https://github.com/marian13/convenient_service/commit/14652d77b6518d1b4ba75fa88eea6aba20ee0e5f))
* **array-based-cache:** add array-based cache implementation ([795888a](https://github.com/marian13/convenient_service/commit/795888a15dbd1e488fe824e6bb8094b9997044e3))
* **be_result:** add trigger for BE_RESULT ([d7a416e](https://github.com/marian13/convenient_service/commit/d7a416e39377378655740d9997695c0100b60258))
* **be_result:** introduce comparing_by ([c304fa7](https://github.com/marian13/convenient_service/commit/c304fa7e4eb15aeae2da075a7947ae835759a605))
* **cache:** introduce thread safe array ([b592853](https://github.com/marian13/convenient_service/commit/b5928536a7dc3e804d386c553da5b9b1e3da1291))
* **call_chain_next:** introduce with_any_arguments ([17316d1](https://github.com/marian13/convenient_service/commit/17316d1f4d6f172f81cc0752ddfb36b9bb8338da))
* **can_be_own_result:** introduce new plugin ([ba7111c](https://github.com/marian13/convenient_service/commit/ba7111c2e01e758affa0e71a4638049fce206243))
* **can_be_tried:** inroduce CanBeTried for result ([9e68538](https://github.com/marian13/convenient_service/commit/9e68538df1207b5bd7906203728b3860324c6d6c))
* **can_be_tried:** introduce step try option ([9c1f493](https://github.com/marian13/convenient_service/commit/9c1f4932b3bf8986624dde9c40580e76b0a0a7ac))
* **can_have_checked_status:** refactor marks_result_status_as_checked to have an ability of a pure status check ([86750dd](https://github.com/marian13/convenient_service/commit/86750dd826ad9b6b8f84e6d26182ac16ec769b8c))
* **can_have_steps:** allow to pass extra kwargs to step definition ([bd867e3](https://github.com/marian13/convenient_service/commit/bd867e3d7e1147889dab982e2b7bea49a95a3d90))
* **can_have_steps:** introduce Step#resolved_result ([68ee612](https://github.com/marian13/convenient_service/commit/68ee612800e61e09e3fb9e18a418ee09261da0bc))
* **can_have_stubbed_results:** use thread safe array backend ([45b9e24](https://github.com/marian13/convenient_service/commit/45b9e249052e154123e1a014a16df0b2b165268b))
* **can_have_try_result:** introduce middleware ([da24051](https://github.com/marian13/convenient_service/commit/da24051cd240a4ec90f3a970f9f721ec13160dc8))
* **can_have_try_result:** introduce Service.try_result ([92914dc](https://github.com/marian13/convenient_service/commit/92914dc3090774baa455e59709bb79a6b8c8c48a))
* **can_have_try_result:** introduce Service#try_result ([521e80f](https://github.com/marian13/convenient_service/commit/521e80f5909bb2c0373a340cb2f4e4c7f3b790c1))
* **can_have_try_result:** use in minimal config ([bf1135d](https://github.com/marian13/convenient_service/commit/bf1135df3bb650ee4190cbfba7bc2c52bec21885))
* **can_utilize_finite_loop:** introduce new plugin ([b161ecf](https://github.com/marian13/convenient_service/commit/b161ecf062e9ef2484862d00eadf5ed7cab6c628))
* **collects_services_in_exception:** add initial version of plugin ([720267a](https://github.com/marian13/convenient_service/commit/720267ab070225892db9743aa379935f16a4b0b5))
* **configs:** add ok? and not_ok? aliases for success? and not_success? ([5dfb378](https://github.com/marian13/convenient_service/commit/5dfb378ea905bf0fd12e0a78b812ecc208efdf2a))
* **core:** add trigger for RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD ([d419985](https://github.com/marian13/convenient_service/commit/d419985dca3e348b1ee8607aadfd2ea4a0cc84be))
* **core:** commit config from .new ([9e252a0](https://github.com/marian13/convenient_service/commit/9e252a0094e8d55fa5d51c0c33b867f6e16d1882))
* **core:** introduce has_committed_config? ([ae01495](https://github.com/marian13/convenient_service/commit/ae01495c5360675a1a7e825e90f1993c38392d70))
* **core:** introduce middleware arguments ([5ca7868](https://github.com/marian13/convenient_service/commit/5ca7868181d44f0f1eb1f2958270e4c6bbb76646))
* **core:** introduce Middleware.with ([4272262](https://github.com/marian13/convenient_service/commit/427226258cce031679c51a5b4ea900506c995c4a))
* **core:** introduce MiddlewareCreator ([d1b6ce8](https://github.com/marian13/convenient_service/commit/d1b6ce89fdc008359f9fd0ed080c3cfb28bd39b7))
* **core:** introduce observable middleware ([f767a13](https://github.com/marian13/convenient_service/commit/f767a13272bcdd4dd7171a9d0bdf4bb8d7f425d7))
* **core:** introduce observe and use_and_observe ([c19f624](https://github.com/marian13/convenient_service/commit/c19f6246689b3c222d87ff16bba8b65d7b1c04f5))
* **core:** MiddlewareCreator#new ([e36cee9](https://github.com/marian13/convenient_service/commit/e36cee97a8cceb70fe7564bde516dc31f4b37157))
* **core:** track method_missing commit triggers ([f3a7264](https://github.com/marian13/convenient_service/commit/f3a7264e3ddb67976fbf2e1c875df15f6f133c0b))
* **debug:** add Step#output_values without specs ([b7e4712](https://github.com/marian13/convenient_service/commit/b7e47126b22fa93d29198b9e6843a395c4eaad7c))
* **delegate_to:** add with_any_arguments ([f296e53](https://github.com/marian13/convenient_service/commit/f296e53f19b57128e45cc25cc10edac010ba671c))
* **depencency_container:** introduce entry ([a905b6e](https://github.com/marian13/convenient_service/commit/a905b6e90cf656a409246f17be84d39c3b4f79c6))
* **feature:** introduce initial feature ([7413273](https://github.com/marian13/convenient_service/commit/7413273af1d5abad4aee912cc8bffe8f1d6d1d0b))
* **has_awesome_print_inspect:** add initial has_awesome_print_inspect for result ([8437efe](https://github.com/marian13/convenient_service/commit/8437efe19601f73b333544de2b9522642b313e1e))
* **has_awesome_print_inspect:** add initial has_awesome_print_inspect for service ([0e5d3c0](https://github.com/marian13/convenient_service/commit/0e5d3c0021e05b6bea10817fc27d23628ef00a04))
* **has_awesome_print_inspect:** add initial has_awesome_print_inspect for step ([d192327](https://github.com/marian13/convenient_service/commit/d1923276309f044ccb7f6793bc099257aa7970e3))
* **has_awesome_print_inspect:** add initial HasAwesomePrintInspect for Data ([b5a9b7b](https://github.com/marian13/convenient_service/commit/b5a9b7b8c67f3ee22ee711d8417959918a942630))
* **has_inspect:** show anonymous class ([87cc634](https://github.com/marian13/convenient_service/commit/87cc63469cb8ecaacc4dbab4817bf43e91cb3e86))
* **has_inspect:** show anonymous class ([5dc7779](https://github.com/marian13/convenient_service/commit/5dc7779f86431492d6fdbbc2386410c41b5f9164))
* **has_j_send_status_and_attributes:** add public creators ([a954ef2](https://github.com/marian13/convenient_service/commit/a954ef2cd8020fc8158eba864883e15f0442630b))
* **has_j_send_status_and_attributes:** allow to compare code by #=== ([54b5025](https://github.com/marian13/convenient_service/commit/54b502580e2e326bb319c4a7de050242bacdf0ba))
* **has_j_send_status_and_attributes:** allow to compare data by #=== ([a5ce835](https://github.com/marian13/convenient_service/commit/a5ce835da8c0d920dc4a45baf2e599071867511e))
* **has_j_send_status_and_attributes:** allow to compare message by #=== ([ddd5ffd](https://github.com/marian13/convenient_service/commit/ddd5ffd16596fd4288273df980b9a5c150cdbb1b))
* **has_j_send_status_and_attributes:** introduce Code.=== ([c2414cc](https://github.com/marian13/convenient_service/commit/c2414cc251c754b6d405494ed2d6e241457e71ff))
* **has_j_send_status_and_attributes:** introduce Data.=== ([d47202d](https://github.com/marian13/convenient_service/commit/d47202d164fa6215f730d4c75914fd2b53ef7734))
* **has_j_send_status_and_attributes:** introduce Message.=== ([f936fae](https://github.com/marian13/convenient_service/commit/f936fae60a3743c97ea84ceada6c7bc59d59ece6))
* **has_j_send_status_and_attributes:** introduce Status.=== ([494a9b3](https://github.com/marian13/convenient_service/commit/494a9b3b9b5cdd8df737c941c93bdbfbb771115f))
* **has_j_send_status_and_attributes:** link result to status, data, message, code ([dd87723](https://github.com/marian13/convenient_service/commit/dd877234c300151053bae45fd9ae9aac9b74711a))
* **has_j_send_status_and_attributes:** respect RSpec argument matchers via #=== ([c163b32](https://github.com/marian13/convenient_service/commit/c163b3207bd7fdfec1c5ff1a222de80210f1e6fd))
* **has_j_send_status_and_attributes:** support partial data matching ([154a4fd](https://github.com/marian13/convenient_service/commit/154a4fda1a83135cabf6fb31b6b65bb6cec3916f))
* **has_jsend_status_and_attributes:** allow user to provide Code, Data, Message and Status classes ([ff9703e](https://github.com/marian13/convenient_service/commit/ff9703e91c310d6223fbf8c9142c9e41d58498ba))
* **has_mermaid_flowchart:** introduce experimental flowchart ([73475e6](https://github.com/marian13/convenient_service/commit/73475e6f7067439b867a7d9d193d9759dbfa41cf))
* **has_result_status_check_short_syntax:** Add two more short bool result checks ([a8a8a8b](https://github.com/marian13/convenient_service/commit/a8a8a8b2c7d6ff90249488dffff892dff90bf914))
* **has_result:** export commands.is_result? ([17e6bb6](https://github.com/marian13/convenient_service/commit/17e6bb60638f521728735baddab5a623d81e91fd))
* **has_result:** introduce Commands::IsResult ([94e337a](https://github.com/marian13/convenient_service/commit/94e337a93e4724b7382d6afbfc802ac5601c1cad))
* **logger:** add version class ([2e5b236](https://github.com/marian13/convenient_service/commit/2e5b2361caf87d6e08854f7b7c53d2d90cc31a60))
* **logger:** provide fallback for older loggers ([6bbefdc](https://github.com/marian13/convenient_service/commit/6bbefdcd2cceee20588a482af0725b380f897c87))
* **method_middlewares:** introduce #next_arguments ([a878d51](https://github.com/marian13/convenient_service/commit/a878d511bc8cefabd434d38a0502949bc2604de6))
* **middlewares:** add intended entity ([d1a5a0f](https://github.com/marian13/convenient_service/commit/d1a5a0fe6b87cc47ab4f9c85722a2707518777f8))
* **paint:** add version class ([118c650](https://github.com/marian13/convenient_service/commit/118c650c45c8cac20cc9a8c7411b5b091a77b5e0))
* **rescues_result_unhandled_exceptions:** read max_backtrace_size from middleware arguments ([6d7de5e](https://github.com/marian13/convenient_service/commit/6d7de5ecd38d2a9bc7bc719aa44e86f3a31694d7))
* **result:** introduce CanBeStubbed plugin ([9a41145](https://github.com/marian13/convenient_service/commit/9a41145a5c100a4bc3169fda34ffb0574edc01ab))
* **ruby_middleware:** add support of middleware creators ([06bcc15](https://github.com/marian13/convenient_service/commit/06bcc15f6f600e4fc40ec7e1842495f2b37edfd0))
* **ruby:** check if truffleruby ([341ced1](https://github.com/marian13/convenient_service/commit/341ced193953cd8c51a97ac3c4cb8822433485f0))
* **service:** extract RaisesOnNotResultReturnValue ([4de15bc](https://github.com/marian13/convenient_service/commit/4de15bce4fbb4f190fdd79a5a478a8e12a5843a2))
* **sets_parent_to_foreign_result:** include foreign result into parents enum ([b680678](https://github.com/marian13/convenient_service/commit/b680678ee32c2797993084ef4f4a1f18fb01e4f2))
* **step:** add Step#method_step? ([caefe8e](https://github.com/marian13/convenient_service/commit/caefe8e28ce75fece673998de2181c7d94cc4029))
* **stub_service:** add trigger for STUB_SERVICE ([047c835](https://github.com/marian13/convenient_service/commit/047c8358cafd86d84ced0f300440d4a08ee10994))
* **stub_service:** introduce Service::CountsStubbedResultsInvocations and Result::HasStubbedResultInvocationsCounter ([88860a5](https://github.com/marian13/convenient_service/commit/88860a5917f88362670b0fc830b97de79ae83732))
* **stub_service:** use result stubs by service instances ([3dde79b](https://github.com/marian13/convenient_service/commit/3dde79bdbedfa03abe94f979475cbdb8ee40d799))
* **support:** add default for finite_loop ([e1c14b9](https://github.com/marian13/convenient_service/commit/e1c14b9b6e221b521714e1742001d44ac57f0d31))
* **support:** introduce anything ([4a4a287](https://github.com/marian13/convenient_service/commit/4a4a28754aa4325e434e6bce11735e8837680e50))
* **support:** safe_method ([b37d735](https://github.com/marian13/convenient_service/commit/b37d735c03b08e57d930c9d5cb1c7cd089a07e0a))
* **support:** ThreadSafeCounter#current_value= ([bf703bb](https://github.com/marian13/convenient_service/commit/bf703bb80e4bdac62edff930ea9e524012dbd221))
* **utils:** add protected option for Method#defined? ([2bfd1f6](https://github.com/marian13/convenient_service/commit/2bfd1f6210c2774a7f3bb88e9ce7dbb18c40c777))
* **utils:** introduce clamp_class ([ae1712c](https://github.com/marian13/convenient_service/commit/ae1712c3750d256a61d846e052fedd00856b1aa5))
* **utils:** introduce Class#display_name ([5316ec1](https://github.com/marian13/convenient_service/commit/5316ec18d58dbbf017683592f177a3185572c7ff))
* **utils:** introduce Hash#assert_valid_keys ([35b3f68](https://github.com/marian13/convenient_service/commit/35b3f681aa2e544cab7a1c81d00e187325802ad1))
* **utils:** introduce Hash#triple_equality_compare ([4aeb91f](https://github.com/marian13/convenient_service/commit/4aeb91f8c702b7f6b32d1964b2e5153f67fca9dd))
* **utils:** introduce shorter Utils.to_bool ([8713470](https://github.com/marian13/convenient_service/commit/87134707bac542f550ea8dae941bb7c0112b33f0))
* **utils:** introduce String.truncate ([f08e053](https://github.com/marian13/convenient_service/commit/f08e0536b3381e01cd88015bc49036999db58160))


### Bug Fixes

* **be_result:** do not always show JSend attributes ([83c7d20](https://github.com/marian13/convenient_service/commit/83c7d20cc3ada10489abed99ab67c9751739f4f0))
* **cache:** change order of require ([ba20e90](https://github.com/marian13/convenient_service/commit/ba20e90f822c7fb90819a04256929429f0375136))
* **cache:** remove accidentally added file ([fac0105](https://github.com/marian13/convenient_service/commit/fac0105885541a950befe441c081bd03a095f58e))
* **can_be_stubbed_result:** remove typo ([cf9ece7](https://github.com/marian13/convenient_service/commit/cf9ece771b0a97823b0a3f9f1192457b74fa5ef7))
* **can_have_fallback:** precheck status of fallback results ([e7c0468](https://github.com/marian13/convenient_service/commit/e7c04688d20d22595e228cd164f992fa01821b66))
* **can_have_try_result:** return copy to have fresh state ([ba5e86d](https://github.com/marian13/convenient_service/commit/ba5e86d8a3a015e54143b6193bf3a806dfe87d95))
* **can_have_user_provided_entity:** include Core to proto entity as well ([086d15c](https://github.com/marian13/convenient_service/commit/086d15ce2724e8daa7c0ccbe363dea1a1b8fd9fb))
* **contain_exactly:** using `tally` method ([9639f28](https://github.com/marian13/convenient_service/commit/9639f28900143e9873a579d4dd471bb227217dab))
* **core:** disallow config commitment by missing private method ([7b3a20b](https://github.com/marian13/convenient_service/commit/7b3a20bedaf0d3c3cfbcab6a5a0d7a004b673a3b))
* **core:** disallow config commitment by missing private method ([a40d5d1](https://github.com/marian13/convenient_service/commit/a40d5d16abdf9e3c05052adce8caca363834573d))
* **has_j_send_status_and_attributes:** compare by === manually since Hash does NOT have its own === ([31d5782](https://github.com/marian13/convenient_service/commit/31d57820b5e8d6160d40da3ddf25ab73e6bcef32))
* **has_j_send_status_and_attributes:** correct comparison order ([a9def90](https://github.com/marian13/convenient_service/commit/a9def90e772324450f9f2cd6a177df5cef7018c9))
* **has_result_status_check_short_syntax:** Correct implementation of two methods ([5cf6004](https://github.com/marian13/convenient_service/commit/5cf6004bdfe49973452846e452dbcd087074b723))
* **kwargs:** add compatibility between Ruby 2 and 3 ([a361ad7](https://github.com/marian13/convenient_service/commit/a361ad7334df88339fd372a5bf3f44005234c36e))
* **method_collection:** fix failed specs ([baa7e1f](https://github.com/marian13/convenient_service/commit/baa7e1f7e5ab694c61cf7d3422b3673e36e57ab4))
* **middleware_spec:** removed unused require ([0a39c4f](https://github.com/marian13/convenient_service/commit/0a39c4f394fdf484b2cdf20b8e6be5f291fd05c0))
* Remove /gemfiles directory ([4f11a14](https://github.com/marian13/convenient_service/commit/4f11a140bf53bcf1298707dbee2365c053041824))
* **support:** move lock to thread safe counter ([b90f2e7](https://github.com/marian13/convenient_service/commit/b90f2e7f424568d75be8cad6cb71a288ce13b1ce))
* **yard:** remove colon in tags ([81239d7](https://github.com/marian13/convenient_service/commit/81239d7bd37a92de5c727224c992db94e9fe2b61))


### Performance Improvements

* **core:** improve commit_config slightly ([c1738b4](https://github.com/marian13/convenient_service/commit/c1738b4de855a2b3a3f5fa25565f52ccfbd30bb0))
* **core:** improve config.committed? ([283c9ca](https://github.com/marian13/convenient_service/commit/283c9ca30728dfc6311e472d17a69a3dcfcb565b))


### Miscellaneous Chores

* release 0.13.0 ([7373f3e](https://github.com/marian13/convenient_service/commit/7373f3ecba7ded1a949d4a95aeb99a35214ef806))


### Code Refactoring

* **can_have_stubbed_result:** state explicitly cache backend ([b2e4228](https://github.com/marian13/convenient_service/commit/b2e4228708c0e247a1c509c6a04ae39920998eae))
* **has_j_send_result:** rename HasResult to HasJSendResult ([fd6846c](https://github.com/marian13/convenient_service/commit/fd6846c78edd9524eaf0121e77ce4e5a64980974))
* **has_j_send_status_and_attributes:** use Jsend to JSend ([ffb2642](https://github.com/marian13/convenient_service/commit/ffb26424f9ce8f176a148c146c238a2bb1c77ce6))
* **has_result_short_syntax:** allow to pass message to failures ([4a07a38](https://github.com/marian13/convenient_service/commit/4a07a38ac36cb1564059c9ad39a5c4c007db0f82))

## [0.12.0](https://github.com/marian13/convenient_service/compare/v0.11.0...v0.12.0) (2023-04-01)


### ⚠ BREAKING CHANGES

* **has_j_send_status_and_attributes:** use Jsend to JSend
* **can_have_method_steps:** bring back CanHaveMethodSteps since it is thread-safe

### Features

* **be_result:** add trigger for BE_RESULT ([d7a416e](https://github.com/marian13/convenient_service/commit/d7a416e39377378655740d9997695c0100b60258))
* **can_have_method_steps:** bring back CanHaveMethodSteps since it is thread-safe ([cbd4f35](https://github.com/marian13/convenient_service/commit/cbd4f35fa22c85f8005582ac06118d1f63337984))
* **core:** add config constants ([7438742](https://github.com/marian13/convenient_service/commit/7438742268cb808f082cdb9a1a36e8698d73a662))
* **core:** add method_missing_commits_counter ([9f143a0](https://github.com/marian13/convenient_service/commit/9f143a02c49b078ddbb3a953dc657b1c4c992494))
* **core:** add trigger for config commitment in class method missing ([97a4acf](https://github.com/marian13/convenient_service/commit/97a4acf06d30e08411790db917867da53f49653b))
* **core:** add trigger for config commitment in instance method missing ([e1ebfc0](https://github.com/marian13/convenient_service/commit/e1ebfc028d157cadd8a70ebc7321883986db6633))
* **core:** add trigger for RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD ([d419985](https://github.com/marian13/convenient_service/commit/d419985dca3e348b1ee8607aadfd2ea4a0cc84be))
* **core:** add trigger option commit_config! ([2c7c041](https://github.com/marian13/convenient_service/commit/2c7c041f7602710db53e2caf9ab4061579254983))
* **core:** default commit trigger to user ([127822a](https://github.com/marian13/convenient_service/commit/127822a7da2e6e4c95272e627d101f68ce0f5479))
* **core:** introduce config commitment triggers ([b92ee50](https://github.com/marian13/convenient_service/commit/b92ee50d7216b6e49464449f9678071bada0109b))
* **core:** introduce middleware arguments ([5ca7868](https://github.com/marian13/convenient_service/commit/5ca7868181d44f0f1eb1f2958270e4c6bbb76646))
* **core:** introduce Middleware.with ([4272262](https://github.com/marian13/convenient_service/commit/427226258cce031679c51a5b4ea900506c995c4a))
* **core:** introduce MiddlewareCreator ([d1b6ce8](https://github.com/marian13/convenient_service/commit/d1b6ce89fdc008359f9fd0ed080c3cfb28bd39b7))
* **core:** MiddlewareCreator#new ([e36cee9](https://github.com/marian13/convenient_service/commit/e36cee97a8cceb70fe7564bde516dc31f4b37157))
* **core:** track method_missing commit triggers ([f3a7264](https://github.com/marian13/convenient_service/commit/f3a7264e3ddb67976fbf2e1c875df15f6f133c0b))
* **depencency_container:** introduce entry ([a905b6e](https://github.com/marian13/convenient_service/commit/a905b6e90cf656a409246f17be84d39c3b4f79c6))
* **feature:** introduce initial feature ([7413273](https://github.com/marian13/convenient_service/commit/7413273af1d5abad4aee912cc8bffe8f1d6d1d0b))
* **finite_loop:** introduce FiniteLoop.finite_loop ([ae363c1](https://github.com/marian13/convenient_service/commit/ae363c1b159692b5ef42f09bb6250ee7615d4ffe))
* **has_jsend_status_and_attributes:** allow user to provide Code, Data, Message and Status classes ([ff9703e](https://github.com/marian13/convenient_service/commit/ff9703e91c310d6223fbf8c9142c9e41d58498ba))
* **has_result_status_check_short_syntax:** Add two more short bool result checks ([a8a8a8b](https://github.com/marian13/convenient_service/commit/a8a8a8b2c7d6ff90249488dffff892dff90bf914))
* **in_threads:** introduce in_threads RSpec helper ([dbd54ac](https://github.com/marian13/convenient_service/commit/dbd54ac86f75f45ad03bedd2622efc3d7055d4a2))
* **rescues_result_unhandled_exceptions:** read max_backtrace_size from middleware arguments ([6d7de5e](https://github.com/marian13/convenient_service/commit/6d7de5ecd38d2a9bc7bc719aa44e86f3a31694d7))
* **ruby_middleware:** add support of middleware creators ([06bcc15](https://github.com/marian13/convenient_service/commit/06bcc15f6f600e4fc40ec7e1842495f2b37edfd0))
* **ruby:** check if jruby ([fba70da](https://github.com/marian13/convenient_service/commit/fba70daf5713fa99384e860e33c7db32de4b9e91))
* **ruby:** check if truffleruby ([341ced1](https://github.com/marian13/convenient_service/commit/341ced193953cd8c51a97ac3c4cb8822433485f0))
* **stub_service:** add trigger for STUB_SERVICE ([047c835](https://github.com/marian13/convenient_service/commit/047c8358cafd86d84ced0f300440d4a08ee10994))
* support ruby 3.2 in CI and Docker ([4dc26b9](https://github.com/marian13/convenient_service/commit/4dc26b93c074870362cafaaa15d9625542d51b92))
* **support:** introduce thread_safe_counter ([ea25f15](https://github.com/marian13/convenient_service/commit/ea25f159091b7bfd71af593e9dadcdb015606a53))
* **support:** introduce UniqueValue ([b007123](https://github.com/marian13/convenient_service/commit/b0071230455ad80cd206c1e34eb5f59a6f90af61))
* **support:** safe_method ([b37d735](https://github.com/marian13/convenient_service/commit/b37d735c03b08e57d930c9d5cb1c7cd089a07e0a))
* **support:** ThreadSafeCounter#current_value= ([bf703bb](https://github.com/marian13/convenient_service/commit/bf703bb80e4bdac62edff930ea9e524012dbd221))
* **thread_safe_counter:** introduce bincrement and bdecrement ([a0ef972](https://github.com/marian13/convenient_service/commit/a0ef9729eb3bb1e22536375ce7e9cb57a0f7fa7b))
* **unique_value:** add == consistency ([26c8686](https://github.com/marian13/convenient_service/commit/26c8686cbf52caa932d677d080dc283943b048cb))
* **unique_value:** add comparisons ([cf02a50](https://github.com/marian13/convenient_service/commit/cf02a505ca1f34e70d50236f691ebbc89fdcb29f))
* **utils:** introduce Object.resolve_class ([94f6ca2](https://github.com/marian13/convenient_service/commit/94f6ca2178c8bb048b35b10c74d60385fa003079))


### Bug Fixes

* **can_have_steps:** set correct error namaspace ([1f6d647](https://github.com/marian13/convenient_service/commit/1f6d647e1babdd2c565390691a56442ad0fd315c))
* **can_have_stubbed_result:** add thread-safety ([ef77058](https://github.com/marian13/convenient_service/commit/ef77058a877c903a6156875d02d436ac4216174a))
* **core:** remove typo in description ([a34323f](https://github.com/marian13/convenient_service/commit/a34323f1a20a0667aba6fdceb77476345a26d1d3))
* **dependency_container:** remove typo ([fbcfd28](https://github.com/marian13/convenient_service/commit/fbcfd28ccd6747da5c7e7b48aa620206403264e9))
* **has_result_status_check_short_syntax:** Correct implementation of two methods ([5cf6004](https://github.com/marian13/convenient_service/commit/5cf6004bdfe49973452846e452dbcd087074b723))
* **logger:** update ENV variable ([86301ce](https://github.com/marian13/convenient_service/commit/86301ce98bcfa18a4bdb7e4d34c283493865bc76))
* **support:** group examples ([97549e9](https://github.com/marian13/convenient_service/commit/97549e9d2e342041a7d5b64d2bf68dbcedf73ca2))


### Miscellaneous Chores

* release 0.12.0 ([da182b6](https://github.com/marian13/convenient_service/commit/da182b694865ea5e10163193b3219439a6d3be3e))


### Code Refactoring

* **has_j_send_status_and_attributes:** use Jsend to JSend ([ffb2642](https://github.com/marian13/convenient_service/commit/ffb26424f9ce8f176a148c146c238a2bb1c77ce6))

## [0.11.0](https://github.com/marian13/convenient_service/compare/v0.10.1...v0.11.0) (2023-03-04)


### ⚠ BREAKING CHANGES

* **can_have_method_steps:** rename has_result_method_steps to can_have_method_steps
* **can_have_steps:** rename has_result_steps to can_have_steps

### Bug Fixes

* **can_have_method_steps:** disable CanHaveMethodSteps in Standard config ([af0b039](https://github.com/marian13/convenient_service/commit/af0b039c827769441bb5adc150d0e0ff2a43e220))


### Code Refactoring

* **can_have_method_steps:** rename has_result_method_steps to can_have_method_steps ([39901a3](https://github.com/marian13/convenient_service/commit/39901a31e37536ae81c6961b45a8c35e505aaefa))
* **can_have_steps:** rename has_result_steps to can_have_steps ([691d8e1](https://github.com/marian13/convenient_service/commit/691d8e128fc4ff8d1dfa76e365501b0d2028a5aa))


### Miscellaneous Chores

* release 0.11.0 ([dc6282a](https://github.com/marian13/convenient_service/commit/dc6282a7a09e5194c395b2399bd418a0e4d15de9))

## [0.10.1](https://github.com/marian13/convenient_service/compare/v0.10.0...v0.10.1) (2023-03-02)


### Bug Fixes

* **can_have_stubbed_result:** add thread-safety ([1962dcc](https://github.com/marian13/convenient_service/commit/1962dccdea29fb36c1b581e312329f41bb23c179))

## [0.10.0](https://github.com/marian13/convenient_service/compare/v0.9.0...v0.10.0) (2023-03-01)


### Features

* **utils:** introduce Utils::String.demodulize ([87a145a](https://github.com/marian13/convenient_service/commit/87a145a7742e1fce04fa40917dae6ee61e811c71))


### Bug Fixes

* **be_result:** commit config manually ([658e314](https://github.com/marian13/convenient_service/commit/658e3147cad50cb7226c8530227e704bb4c30945))
* **can_have_user_provided_entity:** use demodulized proto entity name ([f25e63c](https://github.com/marian13/convenient_service/commit/f25e63c23a9407ec8cc513311de506781e3cb5ca))
* **has_result_steps:** no validate ([6c14a57](https://github.com/marian13/convenient_service/commit/6c14a572b8fa2dfcb3afef26e64859bb67ac9729))
* **rescues_result_unhandled_exceptions:** add indentation for all message lines ([6458103](https://github.com/marian13/convenient_service/commit/6458103c362c66da42587b1a0bec4935b42606ac))
* **rescues_result_unhandled_exceptions:** use formatted message and class for cause ([c75c389](https://github.com/marian13/convenient_service/commit/c75c3891158ea58d28d8de3718a6296565a1cd84))

## [0.9.0](https://github.com/marian13/convenient_service/compare/v0.8.0...v0.9.0) (2023-02-22)


### ⚠ BREAKING CHANGES

* **export:** add a logic that forbids to use export in classes ([ca81536a](https://github.com/marian13/convenient_service/commit/ca81536a3080661cb762d549f4ef3ce1456bc566))


### Features

* **has_result_short_syntax:** introduce Result#ud, Result#um, Result#uc ([95856c9](https://github.com/marian13/convenient_service/commit/95856c921c14888a3253f1c3d12453dbfd97a14b))
* **utils:** introduce Object#memoize_including_falsy_values ([22b2430](https://github.com/marian13/convenient_service/commit/22b2430f2a57dbded706754261defc53ec140e4f))


### Bug Fixes

* **export:** add a logic that forbids to use export in classes ([ca81536a](https://github.com/marian13/convenient_service/commit/ca81536a3080661cb762d549f4ef3ce1456bc566))

## [0.8.0](https://github.com/marian13/convenient_service/compare/v0.7.0...v0.8.0) (2023-02-20)


### Features

* **aliases:** expose middlewares ([aacb6fd](https://github.com/marian13/convenient_service/commit/aacb6fda4c63e1d82e33c523885bd61397cfb583))
* **configs:** introduce Essential config ([70b0ca8](https://github.com/marian13/convenient_service/commit/70b0ca82679fc89099aee733d91807e371bbed39))
* **rescues_result_unhandled_exceptions:** introduce rescues_result_unhandled_exceptions ([fd0b444](https://github.com/marian13/convenient_service/commit/fd0b4447e5abf81d971cd93a8333a89b363ef1ff))
* **rescues_result_unhandled_exceptions:** return original exception in data + formatted exception as message ([45bc55e](https://github.com/marian13/convenient_service/commit/45bc55ec245df1b95769be761337a3cb2558a878))
* **undefined:** introduce undefined ([2f93bdc](https://github.com/marian13/convenient_service/commit/2f93bdc86d81c9a819bbc1c4a76a0ef291a59b17))
* **wrap_method:** introduce WrappedMethod#chain_exception ([1db33af](https://github.com/marian13/convenient_service/commit/1db33afc3a0e0713700b0bf5385900085af0a2df))


### Bug Fixes

* **wrapped_method:** define chain value even if chain.next raises an exception ([8c4cf95](https://github.com/marian13/convenient_service/commit/8c4cf9534a07e9614fdc73f0d0c019f9c3f0ea54))
* **wrapped_method:** reraise rescued exception ([31f7ab6](https://github.com/marian13/convenient_service/commit/31f7ab6df0b34980656942992d3ecf7a67461d06))

## [0.7.0](https://github.com/marian13/convenient_service/compare/v0.6.0...v0.7.0) (2023-02-13)


### ⚠ BREAKING CHANGES

* **be_result:** introduce #of_step, #of_service, remove #of
* **has_result:** use callbacks before result

### Features

* **be_result:** introduce #of_step, #of_service, remove #of ([0d9ba16](https://github.com/marian13/convenient_service/commit/0d9ba16f035ef50268fdf484b0fd83c58dbb328a))
* **be_result:** of_step supports method steps ([9127301](https://github.com/marian13/convenient_service/commit/9127301f41549fbb8c48b718e410ebd7c100e2e9))
* **can_have_parent_Result:** introduce CanHaveParentResult plugin ([55f0b0f](https://github.com/marian13/convenient_service/commit/55f0b0f558e2edb8b0fdc56a2d8b52bc44995a2f))
* **command:** expose command ([6abcb1a](https://github.com/marian13/convenient_service/commit/6abcb1ad481cad66eba2d4d409e3ce16b0f6591d))
* **configs:** add around callbacks for steps ([cb9d342](https://github.com/marian13/convenient_service/commit/cb9d34204d63a96e89ebebe2991e8ab77b2624f0))
* **has_around_callbacks:** pass arguments to around callbacks ([f682f9a](https://github.com/marian13/convenient_service/commit/f682f9a6fb3ef6e8ab50ccf0f7f3ba375a63092e))
* **can_have_callbacks:** pass arguments to callbacks ([2d7f720](https://github.com/marian13/convenient_service/commit/2d7f720e37a15874ec89167e46fb67a0631ec923))
* **has_jsend_status_and_attributes:** introduce Data#to_s ([c1e20c0](https://github.com/marian13/convenient_service/commit/c1e20c093ec4575a939645a2d951fe4e035154b8))
* **has_result_steps:** add callback trigger for step ([475d46a](https://github.com/marian13/convenient_service/commit/475d46a5abaf6fa85260cef90d78db60146b86d9))
* **has_result_steps:** introduce Step#original_result ([8891247](https://github.com/marian13/convenient_service/commit/8891247e5f0339d9e96e733d05b29e45a2e87e71))
* **has_step:** introduce HasStep plugin ([e6eee96](https://github.com/marian13/convenient_service/commit/e6eee965c8707b7378173f228b9b212834be434b))
* **not_passed:** add better #inspect ([d7ce5d9](https://github.com/marian13/convenient_service/commit/d7ce5d93a3aa5f139f6b7ee578975c1da52488c0))


### Bug Fixes

* **be_descendant_of:** fix typo ([58e0f73](https://github.com/marian13/convenient_service/commit/58e0f73f74685614d24e0ee3c8208a5626f7ef42))
* **be_direct_descendant_of:** fix typo ([bda7d06](https://github.com/marian13/convenient_service/commit/bda7d063d1801309a58b5e4d43d738ebab5fef59))
* **ci:** change the version of yard ([185c23c](https://github.com/marian13/convenient_service/commit/185c23c40dacf997e29d0b7defd10020c22dc196))
* **copyable:** do not mutate input params ([0809592](https://github.com/marian13/convenient_service/commit/08095927ea03c60a00eb3b0d0323458b482827b0))
* **dependency_container:** fix typo ([b1cf420](https://github.com/marian13/convenient_service/commit/b1cf420a2e69cc51e928a8a1ad885a65ad7fb4fe))
* **has_result_steps:** use unsafe attributes in to_kwargs ([6c2b1d3](https://github.com/marian13/convenient_service/commit/6c2b1d3912106f6848b875d06a4d7ce1d79c4edb))
* **has_result_steps:** use unsafe_data ([e00c346](https://github.com/marian13/convenient_service/commit/e00c3468f5761e20678c7019f0d13f2569778b19))
* **has_result:** use callbacks before result ([eb46444](https://github.com/marian13/convenient_service/commit/eb46444536a7cf4aab869aa009c1a7c896c00c11))


### Miscellaneous Chores

* release 0.7.0 ([6433f5a](https://github.com/marian13/convenient_service/commit/6433f5a67c3f21c620d500186e0308fb7b098efc))

## [0.6.0](https://github.com/marian13/convenient_service/compare/v0.5.0...v0.6.0) (2023-01-22)


### Features

* **dependency_container:** assert valid scope ([5d75f59](https://github.com/marian13/convenient_service/commit/5d75f593c01baa695e75fe49af6b4c6b80d7d9b1))
* **singleton_prepend_module:** introduce singleton_prepend_module custom RSpec matcher ([6636b8d](https://github.com/marian13/convenient_service/commit/6636b8d030329e4a6216a934748a70ef4bae6ff3))
* **has_result_steps:** introduce reassign ([75855be](https://github.com/marian13/convenient_service/commit/75855be7fd9115d01d5cfad99d35319486332bd2))

## [0.5.0](https://github.com/marian13/convenient_service/compare/v0.4.0...v0.5.0) (2023-01-19)


### Features

* **dependency_container:** introduce dependency containers ([7e2dd90](https://github.com/marian13/convenient_service/commit/7e2dd9072a4b8815ac74755b4fa2c3b66a093115), [aef8ac0](https://github.com/marian13/convenient_service/commit/aef8ac0ba7fdfdd968fae6e115bb9540bca28ec4))

## [0.4.0](https://github.com/marian13/convenient_service/compare/v0.3.1...v0.4.0) (2023-01-03)


### Features

* **has_jsend_status_and_attributes:** introduce data.has_attribute? ([04e4583](https://github.com/marian13/convenient_service/commit/04e45830fcb4aabc7d6473394e7d4b99e31a11d6))
* **has_result_steps:** add more contextual error message when step result data has no attribute ([5844d94](https://github.com/marian13/convenient_service/commit/5844d942a9bca4b9d4f65403c6c432e9e2b810ad))
* **results_matchers:** introduce be_not_success, be_not_failure, be_not_error ([9bb4454](https://github.com/marian13/convenient_service/commit/9bb4454fa6025bba8200a9280c25ec20cafb4c03))


### Bug Fixes

* **has_result_steps:** print step actual service, not internal wrapper ([c0761be](https://github.com/marian13/convenient_service/commit/c0761be89b8a6dacb318460ed5c55b15fdd2de0b))
* **rspec:** return nil for current example in partially loaded rspec envs ([ea10cc0](https://github.com/marian13/convenient_service/commit/ea10cc0e06dd22022f816f6760af926fb119bdf5))

## [0.3.1](https://github.com/marian13/convenient_service/compare/v0.3.0...v0.3.1) (2022-12-19)


### Bug Fixes

* **can_have_stubbed_result:** fix stubbed_result when it's called in non-test env ([e25178e](https://github.com/marian13/convenient_service/commit/e25178ef502e198d498703172b25e1fb94e702a4))

## [0.3.0](https://github.com/marian13/convenient_service/compare/v0.2.1...v0.3.0) (2022-12-17)


### Features

* **stub_service:** stub_service supports stubbing with different arguments ([766eb5a](https://github.com/marian13/convenient_service/commit/766eb5a25cfbd49b699ca5c0c0ffa5524dc46548))

## [0.2.1](https://github.com/marian13/convenient_service/compare/v0.2.0...v0.2.1) (2022-12-14)


### Bug Fixes

* **has_result_steps:** return step copy to have fresh state ([55cc368](https://github.com/marian13/convenient_service/commit/55cc368484641040c0c76ecb38872cc9a268397c), [fc7cebb](https://github.com/marian13/convenient_service/commit/fc7cebb4e159af7b35eac3cf8c25c7009e14c9d1))
* **standard:** place UsingActiveModelValidations before HasResultSteps ([4c43205](https://github.com/marian13/convenient_service/commit/4c43205382da2e7ae395fea6639c2bcc43d1eec2))
* **standard:** place UsingDryValidation before HasResultSteps ([63c31c0](https://github.com/marian13/convenient_service/commit/63c31c04ac7c2581defd3557aad13db3188806ba))

## [0.2.0](https://github.com/marian13/convenient_service/compare/v0.1.0...v0.2.0) (2022-11-26)


### Features

* **be_success:** add without_data chaining ([e1c7a7e](https://github.com/marian13/convenient_service/commit/e1c7a7e534b4c8c112b343a3318177d69f7ad06d))
* **has_constructor_without_initialize:** introduce .create_without_initialize ([b0835aa](https://github.com/marian13/convenient_service/commit/b0835aaae46820b47ecc57887613acd8599c1908))
* **has_constructor:** introduce .create ([2cc450b](https://github.com/marian13/convenient_service/commit/2cc450bd529596ac8e2fda3d26c2e0b1d4fad959))
* **has_inspect:** indroduce inspect for Service and Result ([c3815c8](https://github.com/marian13/convenient_service/commit/c3815c8d25f47d8f2457ccfbad8660a930e32da1))
* **has_inspect:** introduce HasInspect for Step ([6a6ada7](https://github.com/marian13/convenient_service/commit/6a6ada73962ea96f5e9c40d62e87d91a1e09b961))
* **has_inspect:** introduce inspect for Service and Result ([7c9fe0e](https://github.com/marian13/convenient_service/commit/7c9fe0e4a7aedfcaff1e717f99a934d2fab4c03b))
* **has_result_status_check_short_syntax:** add ability to use short bool result check ([14909c5](https://github.com/marian13/convenient_service/commit/14909c584164a2bd130f788fa48e76edd3c7a758))
* **standard:** use HasConstructorWithoutInitialize ([b16232c](https://github.com/marian13/convenient_service/commit/b16232c88fe75028531cd7e834fb59fece49d122))
* **wrap_method:** add ability to reset wrapped method ([ae01aa8](https://github.com/marian13/convenient_service/commit/ae01aa825dcf0d06b2abdc693331dccb65d95d6b))


## 0.1.0
