use fxhash::FxHashSet;
use std::iter::repeat_with;
use std::time::{Duration, Instant};

fn primes(n: usize) -> Vec<usize> {
    let mut result = Vec::new();
    let mut bools = vec![true; n];

    for i in 2..n {
        if bools[i] {
            result.push(i);

            for j in (i * i..n).step_by(i) {
                bools[j] = false;
            }
        }
    }
    result
}

fn goldback(n: usize) -> bool {
    let prime_list = primes(n);
    let set = FxHashSet::from_iter(&prime_list);

    for i in (4..n).step_by(2) {
        let mut found = false;
        for p in &prime_list {
            if p > &i {
                break;
            } else {
                let q = i - p;
                if set.contains(&q) {
                    found = true;
                    break;
                }
            }
        }
        if !found {
            return false;
        }
    }
    true
}

#[cfg(test)]
mod test {
    use super::{goldback, primes};

    #[test]
    fn check_primes() {
        assert_eq!(primes(20), [2, 3, 5, 7, 11, 13, 17, 19]);
        assert_eq!(primes(1_000_000).len(), 78498);
    }

    #[test]
    fn check_goldback() {
        assert!(goldback(20))
    }
}

fn timed_run() -> Duration {
    let upper = 1_000_000;

    // do the actual test and record the durations
    let start_time = Instant::now();
    let result = goldback(upper);
    let stop_time = Instant::now();

    if result {
        println!("Goldback conjecture holds at {upper}");
    } else {
        println!("Goldback conjecture fails at {upper}");
    }

    stop_time.duration_since(start_time)
}

fn main() {
    const ITERATIONS: usize = 10;

    println!("Starting test...");
    let total_time: Duration = repeat_with(timed_run).take(ITERATIONS + 1).skip(1).sum();
    println!("Total time for 10 runs was {:?}", total_time);
    println!("Average time per run was {:?}", total_time / ITERATIONS as u32);
}
