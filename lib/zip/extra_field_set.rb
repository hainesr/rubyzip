require 'forwardable'

module Zip
  class ExtraFieldSet
    extend Forwardable

    def_delegators :@fields, :[], :delete, :length, :size

    # :stopdoc:
    @type_map = {}
    @zip64_id = nil
    @zip64_placeholder_id = nil
    class << self
      attr_reader :type_map, :zip64_id, :zip64_placeholder_id
    end
    # :startdoc:

    def ==(comp)
      return false if length != comp.length

      @fields.each { |k, v| return false if v != comp[k] }

      true
    end

    def initialize(data = nil)
      @fields = {}
      merge(data) unless data.nil?
    end

    def self.register_extra_field_type(clazz)
      return unless clazz.const_defined?(:EXTRA_FIELD_ID)

      @type_map[clazz.const_get(:EXTRA_FIELD_ID)] = clazz
    end

    def self.register_zip64_extra_field_types(main, placeholder)
      register_extra_field_type(main)
      register_extra_field_type(placeholder)
      @zip64_id = main.const_get(:EXTRA_FIELD_ID)
      @zip64_placeholder_id = placeholder.const_get(:EXTRA_FIELD_ID)
    end

    def merge(data)
      return if data.empty?

      data = data.dup
      while data.bytesize.positive?
        id = data.slice!(0, 2)
        size = data.slice!(0, 2).unpack1('v')
        return if size.nil? || size > data.bytesize

        payload = data.slice!(0, size)

        if @fields.member? id
          @fields[id].merge(payload)
        elsif type_map.member? id
          @fields[id] = type_map[id].new(payload)
        else
          @fields[id] = ExtraFields::Unknown.new(payload)
        end
      end
    end

    def create_zip64(size, compressed, offset = nil, start = nil)
      @fields.delete(zip64_placeholder_id)

      @fields[zip64_id] =
        type_map[zip64_id].build(size, compressed, offset, start)
    end

    def prep_zip64_placeholder(local)
      @fields.delete(zip64_id)

      # If this is a local header entry, create a placeholder
      # so we have room to write a zip64 extra field afterwards
      # (we won't know if it's needed until the file data is written).
      if local
        @fields[zip64_placeholder_id] = type_map[zip64_placeholder_id].new
      else
        @fields.delete(zip64_placeholder_id)
      end
    end

    def zip64
      @fields[zip64_id]
    end

    def has_zip64?
      @fields.member? zip64_id
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

    private

    def type_map
      self.class.type_map
    end

    def zip64_id
      self.class.zip64_id
    end

    def zip64_placeholder_id
      self.class.zip64_placeholder_id
    end
  end
end

require_relative 'extra_fields/ntfs'
require_relative 'extra_fields/universal_time'
require_relative 'extra_fields/unix2'
require_relative 'extra_fields/unknown'
require_relative 'extra_fields/zip64'
