# Rubyzip
## Next generation dev branch

This is Rubyzip next-gen. It is a full re-write of Rubyzip from scratch. Rubyzip has become unwieldy to maintain, and would benefit from a new start. Some features, such as encryption, are not implemented in a particularly friendly way - perhaps forced in, rather than planned for.

Along the way we will return to the Zip specification and make sure that we adhere, while also accomodating rogue Zip archives where possible (looking at you, OSX Archive Tool).

### Feature list (incomplete and to be added to)

- [x] Target Ruby 2.7 (2.6 is already EOL).
- [x] Rubocop linting from commit #1.
- [x] Comprehensive tests from commit #1.
- [ ] Complete documentation.
- [x] Library namespace is `Rubyzip`, not `Zip`.
- [x] `InputStream` read-only sequential access to a Zip archive.
- [x] `Entry` to represent an entry in a Zip archive.
- [x] Decompressors selected automatically
- [x] Traditional decryption implemented as filter stream.
- [x] Decryption integrated directly into the input stream pipeline.
- [x] Universal time extra field (UT).
- [x] New Unix extra field (ux) (read only).
- [x] Old Unix extra field (Ux) (read only).
- [x] Old old Unix extra field (UX) (read only).
- [x] NTFS extra field (0x000a) (read only).
- [x] Zip64 extra field (0x0001) (read only).
- [x] CRC32 checks on decompressed entries.
- [x] Configurable CRC32 checks.
- [x] Decompressed size checks (warning).
- [x] Decompressed size checks (error).
- [x] Configurable decompressed size checks.
- [x] UTF-8 by default, but configurable.
- [x] Ignore, but configurably warn about, invalid dates in Zip archives.
- [x] Handle streamed Zip entries (GP bit 3).
- [x] Handle archives created by OSX Archive Tool (non-standard streamed).
- [ ] `OutputStream` and other writing APIs.
- [ ] Central Directory reading.
- [ ] Central Directory writing.
- [ ] File level access (similar to `Zip::File` currently).
- [ ] Filesystem-like access (similar to `Zip::Filesystem` currently).
