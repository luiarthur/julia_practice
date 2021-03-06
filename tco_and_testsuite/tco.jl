module LogFact

using Lazy, Base.Test
export logfact, logfact_woTCO

function logfact(n)
 @bounce function loop(N, acc) 
   N == 0? acc : loop(N-1, log(N) + acc)
 end
 x = loop(n,0.0)
 println(x)
 x
end

function logfact_woTCO(n)
 function loop(N, acc) 
   N == 0? acc : loop(N-1, log(N) + acc)
 end
 loop(n,0)
end

end

#=
include("tco.jl")
  B = 10000000
  @test logfact(3) == log(6)
  @test logfact_woTCO(3) == log(6)

  @time logfact(500)
  @time logfact_woTCO(500)

  logfact(B)
  logfact_woTCO(B)

  @>> (1:10) map(x -> x*2) filter(iseven)
=#
