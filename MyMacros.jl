module MyMacros
export vtest, @vtest

"""
I'd like to be able to do this:

```julia
@TestSuite let
  @vtest "Test 1" mysum(3,5) == 8
  @vtest "Test 2" true
  @vtest "Test 3" some_syntax_error
  @vtest "Test 4" mysum(3,5) == 7
end
```

and have it print:
```julia

Passed Test 1
Passed Test 2
Error in Test 3
Failed Test 4

Passed 3 of 4 tests
```
"""
function vtest(s:: AbstractString, ex::Expr)
  return :(try print_with_color($ex ? :cyan : :black,
                    ($ex ? "Passed" : "Failed") * 
                     " Test: " * $s * "\n")
    catch
      print_with_color(:red, "Error in test: " * $s * "\n")
    end)
end
macro vtest(s, ex) vtest(s,ex) end


end

#=
include("MyMacros.jl")
using MyMacros
@vtest "Test 1" 1==1
@vtest "Test 2" true==true
@vtest "Test 3" false
@vtest "Test 4" 1==2
@vtest "Test 5" 1==a
=#
