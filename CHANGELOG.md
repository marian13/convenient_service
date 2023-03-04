# Changelog

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
* **configs:** introduce Minimal config ([70b0ca8](https://github.com/marian13/convenient_service/commit/70b0ca82679fc89099aee733d91807e371bbed39))
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
* **has_callbacks:** pass arguments to callbacks ([2d7f720](https://github.com/marian13/convenient_service/commit/2d7f720e37a15874ec89167e46fb67a0631ec923))
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
