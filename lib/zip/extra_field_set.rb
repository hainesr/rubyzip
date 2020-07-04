require 'forwardable'

module Zip
  class ExtraFieldSet
    extend Forwardable

    def_delegators :@fields, :[], :length, :size

    # :stopdoc:
    @type_map = {}
    class << self
      attr_reader :type_map
    end
    # :startdoc:

    def initialize(data = nil)
      @fields = {}
      merge(data) unless data.nil?
    end

    def self.register_extra_field_type(clazz)
      return unless clazz.const_defined?(:EXTRA_FIELD_ID)

      @type_map[clazz.const_get(:EXTRA_FIELD_ID)] = clazz
    end

    def merge(data)
      return if data.empty?

      fields = {}
      data = data.dup
      while data.bytesize.positive?
        id = data.slice!(0, 2)
        size = data.slice!(0, 2).unpack1('v')
        return if size.nil? || size > data.bytesize

        payload = data.slice!(0, size)

        if fields.member? id
          fields[id].merge(payload)
        elsif self.class.type_map.member? id
          fields[id] = self.class.type_map[id].new(payload)
        else
          fields[id] = ExtraFields::Unknown.new(payload)
        end
      end

      @fields.merge!(fields)
    end

    def to_local_bin
      @fields.map do |id, field|
        id + [field.local_size].pack('v') + field.to_local_bin
      end.join.force_encoding('BINARY')
    end

    def to_c_dir_bin
      @fields.map do |id, field|
        id + [field.c_dir_size].pack('v') + field.to_c_dir_bin
      end.join.force_encoding('BINARY')
    end

    def local_size
      (@fields.size * 4) + @fields.values.sum(&:local_size)
    end

    def c_dir_size
      (@fields.size * 4) + @fields.values.sum(&:c_dir_size)
    end
  end
end

require_relative 'extra_fields/unknown'
