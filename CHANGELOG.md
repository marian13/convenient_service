# Changelog

## [0.4.0](https://github.com/marian13/convenient_service/compare/v0.3.1...v0.4.0) (2023-01-03)


### Features

* **has_jsend_status_and_attributes:** introduce data.has_attribute? ([04e4583](https://github.com/marian13/convenient_service/commit/04e45830fcb4aabc7d6473394e7d4b99e31a11d6))
* **has_result_steps:** add more contextual error message when step result data has no attribute ([5844d94](https://github.com/marian13/convenient_service/commit/5844d942a9bca4b9d4f65403c6c432e9e2b810ad))
* **results_matchers:** introduce be_not_failure, be_not_error ([9bb4454](https://github.com/marian13/convenient_service/commit/9bb4454fa6025bba8200a9280c25ec20cafb4c03))


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
