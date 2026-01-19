# frozen_string_literal: true

require 'thread'

# Demonstrates the difference between a race condition (no mutex)
# and a correct critical section (with mutex).
#
# How it works:
# - We intentionally break `counter += 1` into read -> wait -> write.
#   That forces thread interleaving and makes the race very visible.
# - Without a mutex, many increments are lost.
# - With a mutex, the final counter matches the expected value.

def run_test(label:, use_mutex:, threads_count: 10, increments_per_thread: 50_000)
  counter = 0
  mutex = Mutex.new
  threads = []

  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  threads_count.times do
    threads << Thread.new do
      increments_per_thread.times do
        if use_mutex
          mutex.synchronize do
            # Critical section: read -> write is protected
            tmp = counter
            Thread.pass # encourage context switch
            counter = tmp + 1
          end
        else
          # Race condition: read -> wait -> write is NOT protected
          tmp = counter
          Thread.pass # encourage context switch
          counter = tmp + 1
        end
      end
    end
  end

  threads.each(&:join)

  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  expected = threads_count * increments_per_thread

  puts "\n=== #{label} ==="
  puts "threads: #{threads_count}, increments/thread: #{increments_per_thread}"
  puts "expected: #{expected}"
  puts "actual:   #{counter}"
  puts "lost:     #{expected - counter}"
  puts format("time:     %.3fs", elapsed)

  counter
end

# Run both back-to-back so the difference is obvious.
run_test(label: 'NO MUTEX (race condition)', use_mutex: false)
run_test(label: 'WITH MUTEX (correct)', use_mutex: true)