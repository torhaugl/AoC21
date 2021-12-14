input = "SCSCSKKVVBKVFKSCCSOV"
rules = Dict(
"CP" => "C",
"SF" => "S",
"BH" => "F",
"SS" => "N",
"KB" => "N",
"NO" => "N",
"BP" => "F",
"NK" => "P",
"VP" => "H",
"OF" => "O",
"VH" => "O",
"FV" => "F",
"OP" => "V",
"FP" => "B",
"VB" => "B",
"OK" => "S",
"BS" => "B",
"SK" => "P",
"VV" => "H",
"PC" => "S",
"HV" => "K",
"PS" => "N",
"VS" => "O",
"HF" => "B",
"SV" => "C",
"HP" => "O",
"NF" => "V",
"HB" => "F",
"VO" => "B",
"VN" => "N",
"ON" => "H",
"KV" => "K",
"OV" => "F",
"HO" => "H",
"NB" => "K",
"CB" => "F",
"FF" => "H",
"NH" => "F",
"SN" => "N",
"PO" => "O",
"PH" => "C",
"HH" => "P",
"KF" => "N",
"OH" => "N",
"KS" => "O",
"FH" => "H",
"CC" => "F",
"CK" => "N",
"FC" => "F",
"CF" => "H",
"HN" => "B",
"OC" => "F",
"OB" => "K",
"FO" => "P",
"KP" => "N",
"NC" => "P",
"PN" => "O",
"PV" => "B",
"CO" => "C",
"CS" => "P",
"PP" => "V",
"FN" => "B",
"PK" => "C",
"VK" => "S",
"HS" => "P",
"OS" => "N",
"NP" => "K",
"SB" => "F",
"OO" => "F",
"CV" => "V",
"BB" => "O",
"SH" => "O",
"NV" => "N",
"BN" => "C",
"KN" => "H",
"KC" => "C",
"BK" => "O",
"KO" => "S",
"VC" => "N",
"KK" => "P",
"BO" => "V",
"BC" => "V",
"BV" => "H",
"SC" => "N",
"NN" => "C",
"CH" => "H",
"SO" => "P",
"HC" => "F",
"FS" => "P",
"VF" => "S",
"BF" => "S",
"PF" => "O",
"SP" => "H",
"FK" => "N",
"NS" => "C",
"PB" => "S",
"HK" => "C",
"CN" => "B",
"FB" => "O",
"KH" => "O")

input="NNCB"
rules = Dict(
"CH" => "B",
"HH" => "N",
"CB" => "H",
"NH" => "C",
"HB" => "C",
"HC" => "B",
"HN" => "C",
"NN" => "C",
"BH" => "H",
"NC" => "B",
"NB" => "B",
"BN" => "B",
"BB" => "N",
"BC" => "B",
"CC" => "N",
"CN" => "C")

function rules2(rules)
    rules2 = Dict{String,Vector{String}}()
    for k in keys(rules)
        rules2[k] = [k[1] * rules[k], rules[k] * k[2]]
    end
    return rules2
end

function input2inputpairs(input)
    input_pairs = Dict{String,Int}()
    for i = 1:length(input)-1
        key = input[i:i+1]
        input_pairs[key] = get(input_pairs, key, 0) + 1
    end
    return input_pairs
end

function iterate!(input_pairs, rules_new)
    output_pairs = Dict{String, Int}()

    for pair in keys(input_pairs)
        output_pairs[rules_new[pair][1]] = get(output_pairs, rules_new[pair][1], 0) + input_pairs[pair] 
        output_pairs[rules_new[pair][2]] = get(output_pairs, rules_new[pair][2], 0) + input_pairs[pair] 
        #push!(output_pairs, repeat(rules_new[pair], input_pairs[pair])...)
        input_pairs[pair] = 0
    end

    for pair in keys(output_pairs)
        input_pairs[pair] = get(input_pairs, pair, 0) + output_pairs[pair]
    end
end

function pair2char(input_pairs, input)
    char_dict = Dict{Char, Int}()
    char_dict[input[1]] = 1
    char_dict[input[end]] = 1
    for k in keys(input_pairs)
        char_dict[k[1]] = get(char_dict, k[1], 0) + input_pairs[k]
        char_dict[k[2]] = get(char_dict, k[2], 0) + input_pairs[k]
    end
    for k in keys(char_dict)
        char_dict[k] = char_dict[k] ÷ 2
    end
    return char_dict
end

rules_new = rules2(rules)
input_pairs = input2inputpairs(input)

using BenchmarkTools
function solve2()
    rules_new = rules2(rules)
    input_pairs = input2inputpairs(input)
    for i = 1:40
        iterate!(input_pairs, rules_new)
    end
    char_dict = pair2char(input_pairs, input)
    maximum(values(char_dict)) - minimum(values(char_dict))
end
@benchmark solve2()

input_pairs
char_dict = pair2char(input_pairs, input)
maximum(values(char_dict)) - minimum(values(char_dict))

pair2char(input2inputpairs("NCNBCHB"), input)
input2inputpairs("NCNBCHB")
pair2char(input2inputpairs("NBCCNBBBCBHCB"), input)
input2inputpairs("NBCCNBBBCBHCB")
pair2char(input2inputpairs("NBBBCNCCNBBNBNBBCHBHHBCHB"), input)
input2inputpairs("NBBBCNCCNBBNBNBBCHBHHBCHB")
pair2char(input2inputpairs("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"), input)