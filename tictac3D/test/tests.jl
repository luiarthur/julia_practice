using TestSuite
include("../src/Main.jl")

tests = :(
  using TicTac;
  C = Cube(1,2,3);

  @vtest "This is a stupid test for 1 == 1" 1==1;

  @vtest "Testing Cube" let
    C.r == 1 && C.c == 2 && C.l == 3
    1==1
  end;

  @vtest "Testing Cube z" let
    C.z == 34;
    C.z == 34;
  end;

)

testsuite(tests)

