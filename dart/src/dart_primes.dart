import 'package:dart_primes/dart_primes.dart';

int test() {
  var upper = 1000000;
  Stopwatch watch = Stopwatch();
  watch.start();
  var result = goldbach(upper);
  watch.stop();
  // if (!result) {
  //   print("goldbach conjecture fails at ${upper}");
  // } else {
  //   print("goldbach conjecture holds at ${upper}");
  // }
  watch.stop();
  return watch.elapsedMilliseconds;
}

void main() {
  int sum = 0;
  int count = 0;
  for (int i = 0; i < 11; i++) {
    var ms = test();
    if (i > 0) {
      sum += ms;
      count++;
    }
  }

  var avg = sum / count;
  print("Average in $avg milliseconds");
}
