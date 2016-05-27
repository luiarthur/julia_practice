include("tco.jl")
using Base.Test

function TestTCO()
  numPass = 0
  numFail = 0
  passColor = :cyan
  failColor = :red

  #=
    write a macro @vtest (verbose test) that does this

    @vtest "Name of test" 1==1
  =#

  function custom_handler(r::Test.Success)
    print_with_color(passColor, "Success on test: $(r.expr)\n")
    numPass += 1
  end

  function custom_handler(r::Test.Failure) 
    print_with_color(failColor, "Error on test : $(r.expr)\n")
    numFail += 1
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
    @test let
      x = 1 == 1
      x
    end
    @test let
      x = 1 == 2
      x
    end
    # END OF TESTS:

    printColor = numFail == 0 ? passColor : failColor
    print_with_color(printColor, 
      string("Tests Passed: ", numPass, " of ", numFail + numPass),"\n")
  end
end

#=
  include("TestTCO.jl")
  TestTCO()
=#