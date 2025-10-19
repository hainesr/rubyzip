# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip # :nodoc:
  # Local headers.
  LOC_PACK = 'VCCvvvvVVVvv'
  LOC_SIGN = 0x04034b50     # "PK\x03\x04"
  LOC_SIZE = 30             # Including signature

  # General purpose flags.
  GP_FLAGS_ENCRYPTED = (1 << 0)
  GP_FLAGS_STREAMED  = (1 << 3)
  GP_FLAGS_UTF8      = (1 << 11)

  # File types.
  FILE_TYPE_DIR     = 0o04
  FILE_TYPE_FILE    = 0o10
  FILE_TYPE_SYMLINK = 0o12

  # Filesystem types.
  FS_TYPE_FAT      = 0
  FS_TYPE_AMIGA    = 1
  FS_TYPE_VMS      = 2
  FS_TYPE_UNIX     = 3
  FS_TYPE_VM_CMS   = 4
  FS_TYPE_ATARI    = 5
  FS_TYPE_HPFS     = 6
  FS_TYPE_MAC      = 7
  FS_TYPE_Z_SYSTEM = 8
  FS_TYPE_CPM      = 9
  FS_TYPE_NTFS     = 10
  FS_TYPE_MVS      = 11
  FS_TYPE_VSE      = 12
  FS_TYPE_ACORN    = 13
  FS_TYPE_VFAT     = 14
  FS_TYPE_MVS_ALT  = 15
  FS_TYPE_BEOS     = 16
  FS_TYPE_TANDEM   = 17
  FS_TYPE_OS400    = 18
  FS_TYPE_OS_X     = 19

  FS_TYPES = {
    FS_TYPE_FAT      => 'FAT/VFAT/FAT32',
    FS_TYPE_AMIGA    => 'Amiga',
    FS_TYPE_VMS      => 'OpenVMS',
    FS_TYPE_UNIX     => 'Unix',
    FS_TYPE_VM_CMS   => 'VM/CMS',
    FS_TYPE_ATARI    => 'Atari ST',
    FS_TYPE_HPFS     => 'OS/2 or NT HPFS',
    FS_TYPE_MAC      => 'Macintosh',
    FS_TYPE_Z_SYSTEM => 'Z-System',
    FS_TYPE_CPM      => 'CP/M',
    FS_TYPE_NTFS     => 'Windows NTFS',
    FS_TYPE_MVS      => 'MVS (OS/390 - Z/OS)',
    FS_TYPE_VSE      => 'VSE',
    FS_TYPE_ACORN    => 'Acorn RISC OS',
    FS_TYPE_VFAT     => 'Win32 VFAT',
    FS_TYPE_MVS_ALT  => 'MVS (alternate)',
    FS_TYPE_BEOS     => 'BeOS',
    FS_TYPE_TANDEM   => 'Tandem NSK',
    FS_TYPE_OS400    => 'OS/400',
    FS_TYPE_OS_X     => 'Mac OS X (Darwin)'
  }.freeze

  # Compression methods.
  COMPRESSION_METHOD_STORE       = 0
  COMPRESSION_METHOD_SHRINK      = 1
  COMPRESSION_METHOD_REDUCE_1    = 2
  COMPRESSION_METHOD_REDUCE_2    = 3
  COMPRESSION_METHOD_REDUCE_3    = 4
  COMPRESSION_METHOD_REDUCE_4    = 5
  COMPRESSION_METHOD_IMPLODE     = 6
  # RESERVED                     = 7
  COMPRESSION_METHOD_DEFLATE     = 8
  COMPRESSION_METHOD_DEFLATE_64  = 9
  COMPRESSION_METHOD_PKWARE_DCLI = 10
  # RESERVED                     = 11
  COMPRESSION_METHOD_BZIP2       = 12
  # RESERVED                     = 13
  COMPRESSION_METHOD_LZMA        = 14
  # RESERVED                     = 15
  COMPRESSION_METHOD_IBM_CMPSC   = 16
  # RESERVED                     = 17
  COMPRESSION_METHOD_IBM_TERSE   = 18
  COMPRESSION_METHOD_IBM_LZ77    = 19
  COMPRESSION_METHOD_ZSTD        = 93
  COMPRESSION_METHOD_MP3         = 94
  COMPRESSION_METHOD_XZ          = 95
  COMPRESSION_METHOD_JPEG        = 96
  COMPRESSION_METHOD_WAVPACK     = 97
  COMPRESSION_METHOD_PPMD        = 98
  COMPRESSION_METHOD_AES         = 99

  COMPRESSION_METHODS = {
    COMPRESSION_METHOD_STORE       => 'Store (no compression)',
    COMPRESSION_METHOD_SHRINK      => 'Shrink',
    COMPRESSION_METHOD_REDUCE_1    => 'Reduce with compression factor 1',
    COMPRESSION_METHOD_REDUCE_2    => 'Reduce with compression factor 2',
    COMPRESSION_METHOD_REDUCE_3    => 'Reduce with compression factor 3',
    COMPRESSION_METHOD_REDUCE_4    => 'Reduce with compression factor 4',
    COMPRESSION_METHOD_IMPLODE     => 'Implode',
    # RESERVED = 7
    COMPRESSION_METHOD_DEFLATE     => 'Deflate',
    COMPRESSION_METHOD_DEFLATE_64  => 'Deflate64(tm)',
    COMPRESSION_METHOD_PKWARE_DCLI => 'PKWARE Data Compression Library Imploding (old IBM TERSE)',
    # RESERVED = 11
    COMPRESSION_METHOD_BZIP2       => 'BZIP2',
    # RESERVED = 13
    COMPRESSION_METHOD_LZMA        => 'LZMA',
    # RESERVED = 15
    COMPRESSION_METHOD_IBM_CMPSC   => 'IBM z/OS CMPSC Compression',
    # RESERVED = 17
    COMPRESSION_METHOD_IBM_TERSE   => 'IBM TERSE (new)',
    COMPRESSION_METHOD_IBM_LZ77    => 'IBM LZ77 z Architecture (PFS)',
    COMPRESSION_METHOD_ZSTD        => 'Zstandard (zstd) Compression',
    COMPRESSION_METHOD_MP3         => 'MP3 Compression',
    COMPRESSION_METHOD_XZ          => 'XZ Compression',
    COMPRESSION_METHOD_JPEG        => 'JPEG variant',
    COMPRESSION_METHOD_WAVPACK     => 'WavPack compressed data',
    COMPRESSION_METHOD_PPMD        => 'PPMd version I, Rev 1',
    COMPRESSION_METHOD_AES         => 'AE-x encryption marker'
  }.freeze
end
