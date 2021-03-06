module Resque
  # The stat subsystem. Used to keep track of integer counts.
  #
  #   Get a stat:  Stat[name]
  #   Incr a stat: Stat.incr(name)
  #   Decr a stat: Stat.decr(name)
  #   Kill a stat: Stat.clear(name)
  module Stat
    extend self
    extend Helpers

    # Returns the int value of a stat, given a string stat name.
    def get(stat)
      redis.get("stat:#{stat}").to_i
    end

    # Alias of `get`
    def [](stat)
      get(stat)
    end

    # For a string stat name, increments the stat by one.
    #
    # Can optionally accept a second int parameter. The stat is then
    # incremented by that amount.
    def incr(stat, by = 1)
      with_retries do
        redis.incrby("stat:#{stat}", by)
      end
    end

    # Increments a stat by one.
    def <<(stat)
      incr stat
    end

    # For a string stat name, decrements the stat by one.
    #
    # Can optionally accept a second int parameter. The stat is then
    # decremented by that amount.
    def decr(stat, by = 1)
      with_retries do
        redis.decrby("stat:#{stat}", by)
      end
    end

    # Decrements a stat by one.
    def >>(stat)
      decr stat
    end

    # Removes a stat from Redis, effectively setting it to 0.
    def clear(stat)
      with_retries do
        redis.del("stat:#{stat}")
      end
    end
  end
end
