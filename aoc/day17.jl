# target area:
target_x=25:67
target_y=-260:-200

solve1(target_y) = (minimum(target_y) * (minimum(target_y) - 1)) ÷ 2
solve1(target_y)

function in_target(vel_x, vel_y)

    vx = vel_x
    vy = vel_y
    x = 0
    y = 0
    while x <= maximum(target_x) && y >= minimum(target_y)
        x += vel_x
        y += vel_y
        if vel_x > 0
            vel_x -= 1
        end
        vel_y -= 1
        if x ∈ target_x && y ∈ target_y
            return true
        end
    end
    return false
end

paths = 0
for vx = 7:67, vy = -260:259
    paths += in_target(vx, vy)
end
paths