## C#

This is the C# version of the program.

This is a version that can scale up to much larger number of primes because it uses a
generator approach to keeping track of all multiples of prime numbers stored in a
priority queue as per https://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf.

Assuming you have installed the DotNet 7.0 SDK you can build it and run it like this:

1. dotnet build --configuration Release
3. bin\x64\Release\net7.0\dotnet_primes.exe 100000
