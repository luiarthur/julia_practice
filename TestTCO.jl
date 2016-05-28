#= See:
http://docs.julialang.org/en/release-0.4/manual/metaprogramming/
http://docs.julialang.org/en/release-0.4/stdlib/test/
http://docs.julialang.org/en/release-0.4/manual/control-flow/#man-exception-handling
https://www.youtube.com/watch?v=EpNeNCGmyZE
=#

include("tco.jl")
include("MyMacros.jl")
using Base.Test, MyMacros, LogFact


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
    #print_with_color(passColor, "Passed test: $(r.expr)\n")
    numPass += 1
  end

  function custom_handler(r::Test.Failure)
    #print_with_color(failColor, "Failed test : $(r.expr)\n")
    numFail += 1
  end

  function custom_handler(r::Test.Error) 
    #print_with_color(failColor, "Error in test: $(r.expr)\n")
    numFail += 1
  end


  Test.with_handler(custom_handler) do
    println()

    # TESTS GO HERE:
    @vtest "Arthur" (1==1)
    @vtest "is " logfact(3) == log(6)
    @vtest "Test 3" logfact_woTCO(3) == log(6)
    @vtest "1 == 2" 1 == 2 
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
    println()
    print_with_color(printColor, 
      string("Tests Passed: ", numPass, " of ", numPass + numFail),"\n")
  end
end

#=
  include("TestTCO.jl")
  TestTCO()
=#
