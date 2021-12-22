using Test

struct Player
    score
    space
end

function solve1(start1, start2)
    dist(start, dist) = (start - 1 + dist) % 10 + 1
    function take_turn(p :: Player, die)
        sp = p.space
        out = sum(die+1:die+3)
        die += 3
        sp = dist(sp, out)
        return Player(p.score + sp, sp), die
    end

    p1 = Player(0, start1)
    p2 = Player(0, start2)
    die = 0
    turn = 1
    while p1.score < 1000 && p2.score < 1000
        if isodd(turn)
            p1, die = take_turn(p1, die)
            turn = 2
        else
            p2, die = take_turn(p2, die)
            turn = 1
        end
    end
    return min(p1.score, p2.score) * die
end
@test solve1(4, 8) == 739785
println(solve1(6, 8))

function recursive(start1, start2; ws=21)
    p1 = Player(0, start1)
    p2 = Player(0, start2)
    wins = 0
    for (dice, coeff) in zip(dice_rolls, trinomial)
        wins += recursive_iter(dice, p1, p2, BigInt(coeff), 1; win_score = ws)
        println("\nwins: $wins")
    end
    return wins
end

function recursive_iter(roll, p1, p2, num, turn; win_score=21)
    sp = (p1.space - 1 + roll) % 10 + 1
    p1_new = Player(p1.score + sp, sp)
    if p1_new.score < win_score
        wins = 0
        for (dice, coeff) in zip(dice_rolls, trinomial)
            wins += recursive_iter(dice, p2, p1_new, num*coeff, turn + 1; win_score = win_score)
        end
        return wins
    else
        if isodd(turn)
            return num
        else
            return 0
        end
    end
end

const trinomial = Int[1, 3, 6, 7, 6, 3, 1]
const dice_rolls= Int[3, 4, 5, 6, 7, 8, 9]

#@test recursive(4, 8; ws=21) == 444356092776315
using BenchmarkTools
@benchmark recursive(6, 8; ws=21)