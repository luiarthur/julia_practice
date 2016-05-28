module MyMacros
export @vtest

macro vtest(s:: AbstractString, ex)
  try
    :( print_with_color($ex ? :cyan : :red,
                        ($ex ? "Passed" : "Failed") * 
                        " Test: " * $s * "\n") )
  catch
    :( print_with_color(:red, "Error in test: " * string(s) * "\n") )
  end
end


end

#=
include("MyMacros.jl")
using MyMacros
@vtest "asd" 1==1
@vtest "asd" true==true
@vtest "asd" false
@vtest "asd" 1==2
@vtest "asd" 1==a
=#
