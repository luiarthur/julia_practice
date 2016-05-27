using Lazy

function logfact(n)
 @bounce function loop(N, acc) 
   N == 0? acc : loop(N-1, log(N) + acc)
 end
 loop(n,0.0)
end

function logfact_woTCO(n)
 function loop(N, acc) 
   N == 0? acc : loop(N-1, log(N) + acc)
 end
 loop(n,0)
end

#=
  B = 10000000
  @test logfact(3) == log(6)
  @test logfact_woTCO(3) == log(6)

  @time logfact(500)
  @time logfact_woTCO(500)

  logfact(B)
  logfact_woTCO(B)

  @>> (1:10) map(x -> x*2) filter(iseven)
=#

#= Testing:

function custom_handler(r::Test.Success) 
  print_with_color(:green,"Success on test: $(r.expr)\n")
  1
end

function custom_handler(r::Test.Failure) 
  print_with_color(:red,"Error on test : $(r.expr)\n")
  0
end

function custom_handler(r::Test.Error) 
  rethrow(r)
end

Test.with_handler(custom_handler) do
       x=  @test 1 == 1
       println(x)
       y =  @test 1 != 1
       println(y)
       z = @test 1 == a
       println(z)
       w = @test 1 == 1
       println(w)
end
=#
