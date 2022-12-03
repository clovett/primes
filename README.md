# primes

Some simple performance benchmarks comparing C#, Dart and Rust for an entirely CPU bound problem (no
I/O).

Times in milliseconds.

| Platform                 | C#     | Dart | Rust | C++   | NodeJs |
|--------------------------|--------|------|------|-------|--------|
| Windows 11 AMD Ryzen 9   | 40     | 76   | 17*  | 46    | 372251 |
| Ubuntu 22.04 AMD Ryzen 9 | 43     | 75   | 17*  | 44    | 357659 |

*Rust at 17ms is using a fast non-cryptographic hash on the HashSet.  Using the normal HashSet you
get 62ms.

NodeJs gets the primes really quickly, but enumerating the primes checking against the dictionary in
the Goldbach algorithm is _really_ slow.

C++ used CL version 19.34.31933 with VS 2022 on Windows and clang 14.0.0 on Ubuntu.
