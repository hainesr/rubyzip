require 'singleton'

module Zip
  module ExtraFields
    class Config
      include Singleton

      def initialize
        @config = {}
        @defaults = {
          ownership: Unix2,
          timestamp: Zip::RUNNING_ON_WINDOWS ? NTFS : UniversalTime
        }

        reset!
      end

      def add(param, default)
        @defaults[param] = default
        @config[param] = default
      end

      def [](param)
        @config[param]
      end

      def []=(param, value)
        @config[param] = value if @defaults.key?(param)
      end

      def reset!
        @defaults.each { |key, value| @config[key] = value }
      end
    end
  end
end
