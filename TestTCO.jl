include("tco.jl")
include("MyMacros.jl")
using Base.Test, LogFact, MyMacros

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
    print_with_color(passColor, "Passed test: $(r.expr)\n")
    numPass += 1
  end

  function custom_handler(r::Test.Failure)
    print_with_color(failColor, "Failed test : $(r.expr)\n")
    numFail += 1
  end

  function custom_handler(r::Test.Error) 
    #rethrow(r)
    print_with_color(failColor, "Error in test : $(r.expr)\n")
  end


  Test.with_handler(custom_handler) do
    println()

    # TESTS GO HERE:
    @vtest "Test 1" (1==1)
    eval( vtest("Test 2.0",:(logfact(3) == log(6))) )
    @vtest "Test 2" logfact(3) == log(6)
    @vtest "Test 3" logfact_woTCO(3) == log(6)
    @vtest "Test 4" 1 == 2 
    @vtest "Test 5" 1 == a
    @vtest "Test 6" let
      x = 1 == 1
      x
    end
    @vtest "Test 7" let
      1 == 2
    end
    @vtest "Test 8" mean(1:3) == mean(4:6) - 3
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
