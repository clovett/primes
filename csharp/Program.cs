using System.Collections.Generic;
using System.Diagnostics;

class Program {
    // Return all primes up to the number 'n'.
    static List<int> primes(long n) {
        List<int> res = new List<int>();
        bool[] buf = new bool[(int)n];
        Array.Fill(buf, true);
        for (long i = 2; i < n; i++) {
            if (buf[i]) {
                res.Add((int)i);
                for (long j = i * i; j < n; j = j + i) {
                    buf[(int)j] = false;
                }
            }
        }
        return res;
    }

    static bool goldbach(int n) {
        var list = primes(n);
        // should be 78498 primes
        HashSet<int> map = new HashSet<int>();
        foreach (var p in list) {
            map.Add(p);
        }
        for (var i = 4; i < n; i += 2) {
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
                return false;
            }
        }
        return true;
    }

    static long Test(){
        Stopwatch watch = new Stopwatch();
        watch.Start();
        var upper = 1000000;
        var result = goldbach(upper);
        // if (!result) {
        //      Console.WriteLine($"goldbach conjecture fails at {upper}");
        // } else {
        //      Console.WriteLine($"goldbach conjecture holds at {upper}");
        // }
        watch.Stop();
        var milliseconds = watch.ElapsedMilliseconds;
        return milliseconds;
    }

    static void Main() {
        long sum = 0;
        long count = 0;
        for (int i = 0; i < 11; i++){
            var ms = Test();
            if (i > 0) {
                sum += ms;
                count++;
            }
        }

        var avg = sum / count;
        Console.WriteLine($"Average in {avg} milliseconds");
    }
}