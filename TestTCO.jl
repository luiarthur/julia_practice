include("tco.jl")
using Base.Test

function TestTCO()
  numPass = 0
  numFail = 0

  #=
    write a macro @vtest (verbose test) that does this

    @vtest "Name of test" 1==1
  =#

  function custom_handler(r::Test.Success)
    print_with_color(:green,"Success on test: $(r.expr)\n")
    numPass = numPass + 1
  end

  function custom_handler(r::Test.Failure) 
    print_with_color(:red,"Error on test : $(r.expr)\n")
    numFail = numPass + 1
  end

  function custom_handler(r::Test.Error) 
    rethrow(r)
  end

  Test.with_handler(custom_handler) do
    println()

    # TESTS GO HERE:
    @test logfact(3) == log(6)
    @test logfact_woTCO(3) == log(6)
    @test 1 == 2
    # END OF TESTS:

    print_with_color(:green, 
      string("Tests Passed: ", numPass, " of ", numFail + numPass),"\n")
  end
end

#=
  include("TestTCO.jl")
  TestTCO()
=#

