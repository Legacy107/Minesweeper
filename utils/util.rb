# Binary search function
def upper_bound(arr, n)
    if arr.empty?()
        return 0
    end

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
    duration = end_time - (start_time || end_time)

    return (duration * 1000).round()
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

def center_box(screen_width, width)
    return screen_width / 2 - (width / 2).round()
end

def center_text(font, text, screen_width)
    return center_box(screen_width, font.text_width(text))
end

def center_image(image, scale, screen_width)
    center_box(screen_width, image.width * scale)
end

def mouse_over_button(mouse_x, mouse_y, bounding_box)
    return (
        (
            mouse_x > bounding_box[0][0] and
            mouse_x < bounding_box[1][0]
        ) and
        (
            mouse_y > bounding_box[0][1] and
            mouse_y < bounding_box[1][1]
        )
    )
end

def util()
    # Driver code for testing
    start = Time.new()
    sleep(3.14)

    puts(get_duration(start))

    puts(format_duration(123456))
end

if __FILE__ == $0
    util()
end
