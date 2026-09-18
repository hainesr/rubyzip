# frozen_string_literal: true

module Zip
  class Inflater < Decompressor # :nodoc:all
    # The number of compressed bytes fed to Zlib in one go. Deflate can
    # expand data by up to ~1000:1, so inflating a whole
    # Decompressor::CHUNK_SIZE (32 KiB) at once can produce over 30 MiB of
    # output for a single small read, all of which sits in @buffer until
    # the caller has read it out. Keeping the input chunk small bounds the
    # amount inflated beyond what the caller asked for to a few MiB in the
    # worst case, without measurably slowing down normal files.
    INPUT_CHUNK_SIZE = 4096

    def initialize(*args)
      super

      @buffer = +''.b
      @zlib_inflater = ::Zlib::Inflate.new(-Zlib::MAX_WBITS)
    end

    def read(maxlen = nil)
      return (maxlen.nil? || maxlen.zero? ? '' : nil) if eof?

      while maxlen.nil? || (@buffer.bytesize < maxlen)
        break if input_finished?

        @buffer << produce_input
      end

      @buffer.slice!(0...(maxlen || @buffer.bytesize))
    end

    def eof?
      @buffer.empty? && input_finished?
    end

    # Alias for compatibility. Remove for version 4.
    alias eof eof?

    private

    def produce_input
      retried = 0
      begin
        @zlib_inflater.inflate(input_stream.read(INPUT_CHUNK_SIZE))
      rescue Zlib::BufError
        raise if retried >= 5 # how many times should we retry?

        retried += 1
        retry
      end
    rescue Zlib::Error => e
      raise ::Zip::DecompressionError, e
    end

    def input_finished?
      @zlib_inflater.finished?
    end
  end

  ::Zip::Decompressor.register(::Zip::COMPRESSION_METHOD_DEFLATE, ::Zip::Inflater)
end

# Copyright (C) 2002, 2003 Thomas Sondergaard
# rubyzip is free software; you can redistribute it and/or
# modify it under the terms of the ruby license.
