def upper_bound(arr, n)
    left = 0
    right = arr.length - 1
    mid = 0

    while left + 1 < right
        mid = (left + right + 1) / 2
        if arr[mid] <= n
            left = mid + 1
        else
            right = mid
        end
    end

    if arr[left] > n
        return left
    elsif arr[right] > n
        return right
    else
        return right + 1
    end
end

def get_duration(start_time)
    end_time = Time.new()
    duration = end_time.to_f() - start_time.to_f()

    return (duration * 10000).round()
end

# Format duration in ms to Am Bs Cms
def format_duration(duration)
    ms = duration % 1000
    duration /= 1000
    s = duration % 60
    duration /= 60
    m = duration

    return "#{m}m #{s}s #{ms}ms"
end

def util()
    # Driver code for testing
    start = Time.new();
    sleep(3.14)

    puts(get_duration(start))

    puts(format_duration(123456))
end

if __FILE__ == $0
    util()
end

