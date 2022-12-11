import 'package:dart2/priority_queue.dart';

class MultipleGenerator {
  int prime = 0;
  int next = 0;

  MultipleGenerator(int n) {
    prime = n;
    next = n + n;
  }

  void advance() {
    next += prime;
  }
}

class Wheel {
  List<int> values = [
    2,
    4,
    2,
    4,
    6,
    2,
    6,
    4,
    2,
    4,
    6,
    6,
    2,
    6,
    4,
    2,
    6,
    4,
    6,
    8,
    4,
    2,
    4,
    2,
    4,
    8,
    6,
    4,
    6,
    2,
    4,
    6,
    2,
    6,
    6,
    4,
    2,
    4,
    6,
    2,
    6,
    4,
    2,
    4,
    2,
    10,
    2,
    10
  ];
  int pos = 0;
  int spin() {
    if (pos >= values.length) {
      pos = 0;
    }
    return values[pos++];
  }
}

Iterable<int> primes(int n) sync* {
  PriorityQueue<MultipleGenerator> gens = PriorityQueue<MultipleGenerator>((a, b) => a.next - b.next);
  yield 2;
  yield 3;
  yield 5;
  yield 7;
  Wheel wheel = Wheel();
  for (int i = 11; i < n; i += wheel.spin()) {
    bool isMultiple = false;
    while (gens.length > 0) {
      var g = gens.first;
      if (i < g.next) {
        break;
      } else {
        if (i == g.next) {
          isMultiple = true;
        }
        gens.remove(g);
        // advance!
        g.advance();
        // the sorting key has changed so re-insert it.
        gens.add(g);
      }
    }
    if (!isMultiple) {
      //Console.WriteLine(i);
      yield i;
      var g = MultipleGenerator(i);
      gens.add(g);
    }
  }
}
