## Dart

This is the Dart version of the program.

This is a version that can scale up to much larger number of primes because it uses a
generator approach to keeping track of all multiples of prime numbers stored in a
priority queue as per https://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf.

Assuming you have installed the Dart SDK you can build it and run it like this:

1. dart pub get
2. dart compile exe bin\dart2.dart
3. bin\dart2.exe
