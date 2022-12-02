var Stopwatch = require('stopwatch-node').StopWatch;

function primes(n) {
    var res = [];
    var buf = Array(n);
    buf.fill(true);

    for (var i = 2; i < n; i++) {
        if (buf[i]) {
            res.push(i);
            for (var j = i * i; j < n; j = j + i) {
                buf[j] = false;
            }
        }
    }
    return res;
}

function goldbach(n) {
    var list = primes(n);
    // should be 78498 primes
    var map = {}
    for (var p in list) {
        map[p] = true;
    }
    for (var i = 4; i < n; i += 2) {
        var found = false;
        for (var p in list) {
            if (p > i) {
                break;
            } else {
                var q = i - p;
                if (map[q]) {
                    found = true;
                    break;
                }
            }
        }
        if (!found) {
            console.log("goldbach failed on " + i);
            return false;
        }
    }
    return true;
}

function main() {
    var sum = 0;
    var count = 0
    for (var i = 0; i < 11; ++i) {
        const sw = new Stopwatch('sw');
        sw.start('time');
        goldbach(1000000);
        sw.stop();

        const times = sw.getTask('time');
        var milliseconds = times?.timeMills;
        console.log(milliseconds);
        if (i > 0) {
            sum += milliseconds;
            ++count;
        }
    }
    console.log("Average in " + (sum / count) + " milliseconds");
}

main()