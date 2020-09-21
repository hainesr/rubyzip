# frozen_string_literal: true

module Zip
  module Util
    class FileClassifier
      CNTRL_LIST = [(0..6), (14..25), (28..31)].sum([], &:to_a).freeze
      ALLOW_LIST = ([9, 10, 13] + (32..255).to_a).freeze

      def self.classify(buffer, length: 256)
        has_allowed = false
        buffer[0...length].each_byte do |b|
          return :binary if CNTRL_LIST.include?(b)

          has_allowed = true if ALLOW_LIST.include?(b)
        end

        has_allowed ? :text : :binary
      end

      def self.text?(buffer)
        classify(buffer) == :text
      end

      def self.binary?(buffer)
        classify(buffer) == :binary
      end
    end
  end
end
