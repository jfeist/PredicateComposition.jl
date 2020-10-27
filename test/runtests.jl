using PredicateComposition
using Test

@testset "PredicateComposition.jl" begin
    tstdata = [(1:i).^2 for i=1:10]
    @test filter(length ≺ 3, tstdata) == [[1],[1,4]]
    @test filter((length ⪰ 3) ⩓ (length ⪯ 5), tstdata) == [[1,4,9],[1,4,9,16],[1,4,9,16,25]]

    counteven(A) = count(iseven,A)
    @test filter(MIN(length,counteven) ≺ 3, tstdata) == [[1],[1,4],[1,4,9],[1,4,9,16],[1,4,9,16,25]]

    @test map(SUM(length,counteven), tstdata) == [1, 3, 4, 6, 7, 9, 10, 12, 13, 15]
    @test SUM(length,counteven).(tstdata) == [1, 3, 4, 6, 7, 9, 10, 12, 13, 15]

    @test count(iseven ⩔ isodd, 1:100) == 100
    @test count(!iseven ⩓ !isodd, 1:100) == 0
    @test count(iscntrl ⩔ isnumeric, Char.(0:100)) == 42
    @test count(iscntrl ⩔ isnumeric, Char.(0:10000)) == 598
    @test count(isletter ⩔ !isascii, Char.(0:100)) == 30
    @test count(isletter ⩔ !isascii, Char.(0:10000)) == 9925
end
