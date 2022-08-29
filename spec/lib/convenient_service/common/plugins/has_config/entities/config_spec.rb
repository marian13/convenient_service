# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasConfig::Entities::Config do
  example_group "instance_methods" do
    let(:config) { described_class.new(hash) }
    let(:hash) { {"foo" => "bar"} }

    describe "#dup" do
      let(:duplicated) { config.dup }

      it "returns duplicated config" do
        expect(config).to eq(duplicated)
      end

      it "copies config" do
        expect(config.object_id).not_to eq(duplicated.object_id)
      end

      context "when config contains array" do
        let(:hash) { {"foo" => ["bar"]} }

        it "returns that array inside config" do
          expect(config["foo"]).to eq(duplicated["foo"])
        end

        it "copies that array" do
          expect(config["foo"].object_id).not_to eq(duplicated["foo"].object_id)
        end

        context "when that array has nestings" do
          let(:hash) { {"foo" => [["bar"]]} }

          it "copies those nestings" do
            expect(config["foo"][0].object_id).not_to eq(duplicated["foo"][0].object_id)
          end
        end

        context "when that array has deep nestings" do
          let(:hash) { {"foo" => [[["bar"]]]} }

          it "copies those nestings" do
            expect(config["foo"][0][0].object_id).not_to eq(duplicated["foo"][0][0].object_id)
          end
        end
      end

      context "when config contains hash" do
        let(:hash) { {"foo" => {"bar" => "baz"}} }

        it "returns that hash inside config" do
          expect(config["foo"]).to eq(duplicated["foo"])
        end

        it "copies that hash" do
          expect(config["foo"].object_id).not_to eq(duplicated["foo"].object_id)
        end

        context "when that hash has nestings" do
          let(:hash) do
            {
              "foo" => {
                "bar" => {
                  "baz" => "qux"
                }
              }
            }
          end

          it "copies those nestings" do
            expect(config["foo"]["bar"].object_id).not_to eq(duplicated["foo"]["bar"].object_id)
          end
        end

        context "when that hash has deep nestings" do
          let(:hash) do
            {
              "foo" => {
                "bar" => {
                  "baz" => {
                    "qux" => "quux"
                  }
                }
              }
            }
          end

          it "copies those nestings" do
            expect(config["foo"]["bar"]["baz"].object_id).not_to eq(duplicated["foo"]["bar"]["baz"].object_id)
          end
        end
      end

      context "when config contains config" do
        let(:hash) { {"foo" => described_class.new} }

        it "returns that config inside config" do
          expect(config["foo"]).to eq(duplicated["foo"])
        end

        it "copies that config" do
          expect(config["foo"].object_id).not_to eq(duplicated["foo"].object_id)
        end

        context "when that config has nestings" do
          let(:hash) do
            {
              "foo" => described_class.new({
                "bar" => described_class.new
              })
            }
          end

          it "copies those nestings" do
            expect(config["foo"]["bar"].object_id).not_to eq(duplicated["foo"]["bar"].object_id)
          end
        end

        context "when that hash has deep nestings" do
          let(:hash) do
            {
              "foo" => described_class.new({
                "bar" => described_class.new({
                  "baz" => described_class.new
                })
              })
            }
          end

          it "copies those nestings" do
            expect(config["foo"]["bar"]["baz"].object_id).not_to eq(duplicated["foo"]["bar"]["baz"].object_id)
          end
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:config) { described_class.new({"foo" => "bar"}) }

        context "when `other' has different class" do
          let(:other) { 42 }

          it "returns false" do
            expect(config == other).to be_nil
          end
        end

        context "when `other' has different `to_h'" do
          let(:other) { described_class.new({"baz" => "qux"}) }

          it "returns false" do
            expect(config == other).to eq(false)
          end
        end

        context "when `other' has same attributes" do
          let(:other) { described_class.new({"foo" => "bar"}) }

          it "returns true" do
            expect(config == other).to eq(true)
          end
        end
      end
    end

    example_group "conversion" do
      describe "#to_h" do
        it "returns hash representation of config" do
          expect(config.to_h).to eq({"foo" => "bar"})
        end

        it "caches its result" do
          expect(config.to_h.object_id).to eq(config.to_h.object_id)
        end
      end

      describe "#to_read_default_write_config" do
        let(:config) { described_class.new({"foo" => "bar"}) }

        let(:read_default_write_config) { ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new({"foo" => "bar"}) }

        it "returns `read_default_write_config' representation of config" do
          expect(config.to_read_default_write_config).to eq(read_default_write_config)
        end

        context "when config has nestings" do
          let(:config) do
            described_class.new(
              {
                "foo" => described_class.new({
                  "bar" => described_class.new
                })
              }
            )
          end

          let(:read_default_write_config) do
            ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new(
              {
                "foo" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new({
                  "bar" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new
                })
              }
            )
          end

          it "returns `read_default_write_config' representations for nestings" do
            expect(config.to_read_default_write_config).to eq(read_default_write_config)
          end
        end

        context "when config has deep nestings" do
          let(:config) do
            described_class.new(
              {
                "foo" => described_class.new({
                  "bar" => described_class.new({
                    "baz" => described_class.new
                  })
                })
              }
            )
          end

          let(:read_default_write_config) do
            ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new(
              {
                "foo" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new({
                  "bar" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new({
                    "baz" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadDefaultWriteConfig.new
                  })
                })
              }
            )
          end

          it "returns `read_default_write_config' representations for nestings" do
            expect(config.to_read_default_write_config).to eq(read_default_write_config)
          end
        end
      end

      describe "#to_read_only_config" do
        let(:config) { described_class.new({"foo" => "bar"}) }

        let(:read_only_config) { ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new({"foo" => "bar"}) }

        it "returns `read_only_config' representation of config" do
          expect(config.to_read_only_config).to eq(read_only_config)
        end

        context "when config has nestings" do
          let(:config) do
            described_class.new(
              {
                "foo" => described_class.new({
                  "bar" => described_class.new
                })
              }
            )
          end

          let(:read_only_config) do
            ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new(
              {
                "foo" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new({
                  "bar" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new
                })
              }
            )
          end

          it "returns `read_only_config' representations for nestings" do
            expect(config.to_read_only_config).to eq(read_only_config)
          end
        end

        context "when config has deep nestings" do
          let(:config) do
            described_class.new(
              {
                "foo" => described_class.new({
                  "bar" => described_class.new({
                    "baz" => described_class.new
                  })
                })
              }
            )
          end

          let(:read_only_config) do
            ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new(
              {
                "foo" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new({
                  "bar" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new({
                    "baz" => ConvenientService::Common::Plugins::HasConfig::Entities::ReadOnlyConfig.new
                  })
                })
              }
            )
          end

          it "returns `read_only_config' representations for nestings" do
            expect(config.to_read_only_config).to eq(read_only_config)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
