import 'dart:collection';

// Return all primes up to the number 'n'.
List<int> primes(int n) {
  List<int> res = [];
  List<bool> buf = List.filled(n, true);
  for (var i = 2; i < n; i++) {
    if (buf[i]) {
      res.add(i);
      for (var j = i * i; j < n; j = j + i) {
        buf[j] = false;
      }
    }
  }
  return res;
}

bool goldbach(int n) {
  var list = primes(n);
  HashSet<int> map = HashSet<int>();
  for (var p in list) {
    map.add(p);
  }
  for (var i = 4; i < n; i += 2) {
    var found = false;
    for (var p in list) {
      if (p > i) {
        break;
      } else {
        var q = i - p;
        if (map.contains(q)) {
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
