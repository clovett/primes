#include <iostream>
#include <vector>
#include <unordered_set>
#include <cstring>
#include "Stopwatch.h"
using namespace std;

class Program
{
public:
    // Return all primes up to the number 'n'.
    static vector<int> primes(int n) {
        vector<int> res;
        bool* buf = new bool[(int)n];
        ::memset(buf, true, n);
        for (int i = 2; i < n; i++) {
            if (buf[i]) {
                res.push_back((int)i);
                uint64_t x = i;
                if (x * x < n) {
                    for (int j = i * i; j < n; j = j + i) {
                        buf[(int)j] = false;
                    }
                }
            }
        }
        return res;
    }

    static bool goldbach(int n) {
        auto list = primes(n);
        // should be 78498 primes
        unordered_set<int> map;
        for (auto p : list) {
            map.insert(p);
        }
        auto end = map.end();
        for (int i = 4; i < n; i += 2) {
            bool found = false;
            for (auto p : list) {
                if (p > i) {
                    break;
                }
                else {
                    int q = i - p;
                    if (map.find(q) != end) {
                        found = true;
                        break;
                    }
                }
            }
            if (!found) {
                std::cout << "goldbach conjecture failed at " << i << "\n";
                return false;
            }
        }
        return true;
    }

    static long test() {
        Stopwatch watch;
        watch.start();
        int upper = 1000000;
        goldbach(upper);
        watch.stop();
        return (long)watch.milliseconds();
    }

    static void Main() {
        long sum = 0;
        long count = 0;
        for (int i = 0; i < 11; i++) {
            auto ms = test();
            if (i > 0) {
                sum += ms;
                count++;
            }
        }

        long avg = sum / count;
        std::cout << "Average in " << avg << " milliseconds" << "\n";;
    }
};

int main(int argc, char* argv[])
{
    Program::Main();
}