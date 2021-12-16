hex2bit = Dict('0' => "0000", '1' => "0001", '2' => "0010", '3' => "0011",
               '4' => "0100", '5' => "0101", '6' => "0110", '7' => "0111",
               '8' => "1000", '9' => "1001", 'A' => "1010", 'B' => "1011",
               'C' => "1100", 'D' => "1101", 'E' => "1110", 'F' => "1111")


abstract type AbstractPacket end
struct LiteralPacket <: AbstractPacket
    version :: Int
    literal :: Int
    length :: Int
end
struct OperatorPacket <: AbstractPacket
    version :: Int
    typeID :: Int
    subpackets :: Vector{AbstractPacket}
    length :: Int
end

function read_literal(bit_str)
    i = 7
    literal_str = ""
    while parse(Int, bit_str[i]) == 1
        literal_str = join([literal_str, bit_str[(1:4) .+ i]])
        i += 5
    end
    literal_str = join([literal_str, bit_str[(1:4) .+ i]])
    #literal_str = strip(literal_str, '0')
    return parse(Int, literal_str; base=2), i+4
end

length(p::LiteralPacket) = p.length

function read_packet(bit_str)
    version = parse(Int, bit_str[1:3]; base=2)
    typeID = parse(Int, bit_str[4:6]; base=2)
    if typeID == 4
        literal, L = read_literal(bit_str)
        return LiteralPacket(version, literal, L), L
    else
        lengthID = parse(Int, bit_str[7]; base=2)
        if lengthID == 0
            L = parse(Int, bit_str[8:22]; base=2)
            input_subpacket = string(bit_str[23:23+L-1])

            current = 1
            list = Vector{AbstractPacket}(undef,0)
            println("START OPERATORPACK")
            println("L:       $L")
            while current < L
                println("current: $current")
                packet, length = read_packet(input_subpacket[current:end])
                println("packet:  $packet")
                println("length:  $length")
                current += length
                push!(list, packet)
            end
            return OperatorPacket(version, typeID, list, L+7+15), L+7+15
        else
            L = parse(Int, bit_str[8:18]; base=2)
            input_subpacket = string(bit_str[19:end])

            current = 1
            current_pack = 0
            list = Vector{AbstractPacket}(undef,0)
            println("START OPERATORPACK")
            println("N:       $L")
            while current_pack < L
                println("current: $current")
                #println("input:   $(input_subpacket[current:end])")
                packet, length = read_packet(input_subpacket[current:end])
                println("packet:  $packet")
                current += length
                current_pack += 1
                push!(list, packet)
            end
            return OperatorPacket(version, typeID, list, current-1+7+11), current+7+11-1
        end
    end
end

version(p::LiteralPacket) = p.version
version(p::OperatorPacket) = p.version + sum(version.(p.subpackets))
version(p)

input = "D2FE28"
solve1(input)
input = "38006F45291200"
solve1(input)
input = "EE00D40C823060"
solve1(input)
input = "8A004A801A8002F478"
solve1(input)
input = "620080001611562C8802118E34"
solve1(input)
input = "C0015000016115A2E0802F182340"
solve1(input)
input = "A0016C880162017C3686B18A3D4780"
solve1(input)
input = readline("aoc/day16.txt")
solve1(input)

function solve1(input)
    bit_str = [hex2bit[c] for c in input] |> join
    p, _ = read_packet(bit_str)
    return version(p)
end

function evaluate(p :: LiteralPacket)
    return p.literal
end

function evaluate(o :: OperatorPacket)
    nums = evaluate.(o.subpackets)
    if o.typeID == 0
        return sum(nums)
    elseif o.typeID == 1
        return prod(nums)
    elseif o.typeID == 2
        return minimum(nums)
    elseif o.typeID == 3
        return maximum(nums)
    elseif o.typeID == 5
        return Int(nums[1] > nums[2])
    elseif o.typeID == 6
        return Int(nums[1] < nums[2])
    elseif o.typeID == 7
        return Int(nums[1] == nums[2])
    else
        error("Invalid typeID $(o.typeID)")
        return 0
    end
end

function solve2(input)
    bit_str = [hex2bit[c] for c in input] |> join
    p, _ = read_packet(bit_str)
    evaluate(p)
end

solve2(input)