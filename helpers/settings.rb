require 'ostruct'
require 'yaml'
require 'json'

module Settings
  module Helpers
    def self.get_settings
      file = File.join(File.dirname(__FILE__), "../config/settings.yml")
      config = YAML.load(open(file))

      OpenStruct.new(config)
    end

    def self.projects_root
      settings = Settings::Helpers.get_settings
      settings['projects_root']
    end

    def self.git_address_prefix
      settings = Settings::Helpers.get_settings
      settings['git_address_prefix']
    end
  end
end