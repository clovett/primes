using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

class Program {

    /// <summary>
    /// Generates infinite stream of multiples of the given number, up to ulong.MaxValue.
    /// </summary>
    class MultipleGenerator
    {
        public ulong Prime;
        public ulong Next;

        public MultipleGenerator(ulong n)
        {
            Prime = n;
            Next = n + n;
        }

        public void Advance()
        {
            Next += Prime;
        }
    }

    class Wheel {
        ulong[] values = new ulong[] { 2,4,2,4,6,2,6,4,2,4,6,6,2,6,4,2,6,4,6,8,4,2,4,2,4,8,6,4,6,2,4,6,2,6,6,4,2,4,6,2,6,4,2,4,2,10,2,10 };
        int pos = 0;
        public ulong Spin (){
            if (pos >= values.Length){
                pos = 0;
            }
            return values[pos++];
        }
    }

    // Return all primes up to the number 'n'.
    static IEnumerable<ulong> primes(ulong n) {

        PriorityQueue<MultipleGenerator, ulong> gens = new PriorityQueue<MultipleGenerator, ulong>();
        yield return 2;
        yield return 3;
        yield return 5;
        yield return 7;
        Wheel wheel = new Wheel();
        for (ulong i = 11; i < n; i += wheel.Spin()) {
            bool isMultiple = false;
            while (gens.TryPeek(out MultipleGenerator g, out ulong priority))
            {
                if (i < g.Next)
                {
                    break;
                }
                else
                {
                    if (i == g.Next) {
                        isMultiple = true;
                    }
                    var g2 = gens.Dequeue();
                    // advance!
                    g2.Advance();
                    // the sorting key has changed so re-insert it.
                    gens.Enqueue(g2, g2.Next);
                }
            }
            if (!isMultiple)
            {
                //Console.WriteLine(i);
                yield return i;
                var g = new MultipleGenerator(i);
                gens.Enqueue(g, g.Next);

            }
        }
    }

    static bool goldbach(ulong n) {
       // should be 78498 primes
       List<ulong> list = new List<ulong>();
       foreach (var p in primes(n)) {
           list.Add(p);
       }
       HashSet<ulong> map = new HashSet<ulong>(list);
       for (ulong i = 4; i < n; i += 2) {
           var found = false;
           foreach (var p in list) {
               if (p > i) {
                   break;
               } else {
                   var q = i - p;
                   if (map.Contains(q)) {
                       found = true;
                       break;
                   }
               }
           }
           if (!found) {
               Console.WriteLine($"goldbach conjecture failed at {i}");
               return false;
           }
       }
       return true;
    }

    static long Test(ulong upper){
        Stopwatch watch = new Stopwatch();
        watch.Start();
        goldbach(upper);
        watch.Stop();
        var milliseconds = watch.ElapsedMilliseconds;
        return milliseconds;
    }

    static long TestPrimes(ulong max){
        Stopwatch watch = new Stopwatch();
        watch.Start();
        List<ulong> p = new List<ulong>(primes(max));
        watch.Stop();
        var milliseconds = watch.ElapsedMilliseconds;
        Console.WriteLine($"Found {p.Count} primes under {max} in {milliseconds} ms");
        return milliseconds;
    }

    static void Main(string[] args) {
        ulong max = 100;
        if (args.Length > 0)
        {
            ulong.TryParse(args[0], out max);
        }
        Stopwatch watch = new Stopwatch();
        watch.Start();

        long sum = 0;
        long count = 0;
        for (int i = 0; i < 11; i++){
           var ms = TestPrimes(max);
           if (i > 0) {
               sum += ms;
               count++;
           }
        }

        var avg = sum / count;
        Console.WriteLine($"Average in {avg} milliseconds");
    }
}