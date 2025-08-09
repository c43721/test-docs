# Test Docs

This is a toy project that is inspired by the
[technical write up from TigerBetle](https://tigerbeetle.com/blog/2025-02-27-why-we-designed-tigerbeetles-docs-from-scratch/)
that implemented static docs generation from markdown using Zig and Pandoc.

I've done modifications to run on Windows.

# Usage

You must have the following installed:

- [Zig](https://ziglang.org/learn/getting-started)
- [Pandoc](https://pandoc.org/getting-started.html)
- Some type of editor

You can then run `zig build` and all of the HTML produced from `/content` folder
will be outputted in the `zig-out` directory.

# Acknowledgements

Thank you to the TigerBeetle team for writing up a fantastic article on this!
