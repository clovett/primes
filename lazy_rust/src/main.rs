use fxhash::FxHashMap;
use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::iter::repeat_with;
use std::time::{Duration, Instant};

#[derive(Debug)]
struct SieveTable<T> {
    /// table of upcoming composite numbers
    table: FxHashMap<T, BinaryHeap<Reverse<T>>>,
}

impl<
        T: std::cmp::Eq
            + std::hash::Hash
            + std::ops::Mul<Output = T>
            + Copy
            + Sized
            + std::ops::Add<Output = T>
            + std::fmt::Debug
            + std::cmp::Ord
            + std::cmp::PartialOrd,
    > SieveTable<T>
{
    pub fn new() -> Self {
        SieveTable {
            table: FxHashMap::default(),
        }
    }

    fn insert(&mut self, num: T, factor: T) {
        self.table
            .entry(num)
            .and_modify(|factors| factors.push(Reverse(factor)))
            .or_insert_with(|| BinaryHeap::from([Reverse(factor)]));
    }

    /// return true if the num does not already exist in the table,
    /// false otherwise
    pub fn check(&mut self, num: T) -> bool {
        // check to see if num exists in the table, and if it does
        // increment and re-add all of the factors for that number.
        let (result, next_nums, factors) = if let Some(factors) = self.table.remove(&num) {
            let (next_nums, factors): (Vec<T>, Vec<T>) = factors
                .into_iter()
                .map(|Reverse(factor)| (num + factor, factor))
                .unzip();

            // do we also need to increment all of the other factors?
            (false, next_nums, factors)
        } else {
            // if the number does not already exist in the table, its a prime?
            // so we should insert it into our table keyed off of num*num as the first product

            // and return true
            (true, vec![num * num], vec![num])
        };

        for (next_num, factor) in next_nums.into_iter().zip(factors) {
            self.insert(next_num, factor);
        }

        result
    }
}

// so this takes an iterator and returns an iterator of a numeric type
// and returns an iterator of prime numbers
#[derive(Debug)]
pub struct Sieve<I, T>
where
    I: Iterator<Item = T>,
{
    iterator: I,
    table: SieveTable<T>,
}

impl<
        I,
        T: std::cmp::Eq
            + std::hash::Hash
            + std::ops::Mul<Output = T>
            + Copy
            + Sized
            + std::ops::Add<Output = T>
            + std::fmt::Debug
            + std::cmp::Ord
            + std::cmp::PartialOrd,
    > Iterator for Sieve<I, T>
where
    I: Iterator<Item = T>,
{
    type Item = T;

    fn next(&mut self) -> Option<Self::Item> {
        // we want to call self.iterator.next() a bunch of times
        // (until we get a prime number)

        loop {
            if let Some(number) = self.iterator.next() {
                // if number < 2 {
                //     continue;
                // } // requires more complex trait bounds?

                if self.table.check(number) {
                    return Some(number);
                }
            } else {
                // end the iteration
                return None;
            }
        }
    }
}

impl<
        T: std::hash::Hash
            + std::marker::Copy
            + std::ops::Mul
            + std::ops::Mul<Output = T>
            + std::ops::Add
            + std::ops::Add<Output = T>
            + std::cmp::Ord
            + std::fmt::Debug,
        I: Iterator<Item = T>,
    > Sieve<I, T>
{
    pub fn new(iterator: I) -> Self {
        let table = SieveTable::new();
        Sieve { iterator, table }
    }
}

pub trait IntoSieve<T, I: Iterator<Item = T>> {
    fn sieve(self) -> Sieve<I, T>;
}

impl<
        T: std::hash::Hash
            + std::marker::Copy
            + std::ops::Mul
            + std::ops::Mul<Output = T>
            + std::ops::Add
            + std::ops::Add<Output = T>
            + std::cmp::Ord
            + std::fmt::Debug,
        I: Iterator<Item = T>,
    > IntoSieve<T, I> for I
{
    fn sieve(self) -> Sieve<I, T> {
        Sieve::new(self)
    }
}

#[cfg(test)]
mod test {
    use super::IntoSieve;

    #[test]
    fn test_sieve_from_iter() {
        let sum: u32 = (0..20).sieve().sum();
        assert_ne!(sum, 0);
    }

    #[test]
    fn test_lower_primes() {
        let known: Vec<u32> = vec![2, 3, 5, 7, 11, 13, 17, 19];
        let computed: Vec<u32> = (2..20).sieve().collect();
        assert_eq!(known, computed);

        // let computed: Vec<u32> = (0..20).sieve().collect();
        // assert_eq!(known, computed);
    }

    #[test]
    fn test_primes_to_1m() {
        assert_eq!((2..1_000_000_u64).sieve().count(), 78498);
    }
}

fn timed_run() -> Duration {
    // do the actual test and record the durations
    let start_time = Instant::now();
    let _ = (2..1_000_000_u64).sieve().count();
    let stop_time = Instant::now();

    stop_time.duration_since(start_time)
}

fn main() {
    const ITERATIONS: usize = 10;

    println!("Starting test...");
    let total_time: Duration = repeat_with(timed_run).take(ITERATIONS + 1).skip(1).sum();
    println!("Total time for 10 runs was {:?}", total_time);
    println!(
        "Average time per run was {:?}",
        total_time / ITERATIONS as u32
    );
}
