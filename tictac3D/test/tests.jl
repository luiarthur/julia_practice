using TestSuite
include("../src/Main.jl")

tests = :(
  using TicTac;
  C = Cube(1,2,3);

  @vtest "This is a stupid test for 1 == 1" 1==1;

  @vtest "Testing Cube" let
    C.r == 1 && C.c == 2 && C.l == 3
  end;

  @vtest "Testing Cube z" C.z == 34;

  @vtest "Testing Cube oob" oob(C) == false;

  @vtest "Testing Cube moveDir" let
    dir = (1,2,3)
    D = moveDir(C,dir)
    TicTac.show(D)
    oob(D) == true;
  end;

  @vtest "Testing Board" let 
    B = Board(Set{Int}([1,2,3]),Set{Int}([]))
    B.comp == Set{Int}([1,2,3])
  end;

  @vtest "Test winning Sets for 4x4x4 = 76" let
    # This is only computed once
    length(winSets) == 76
  end;

  @vtest "Testing Board Init" let
    B = Board(Set{Int}(),Set{Int}())
    B.comp == Set{Int}() && B.human == Set{Int}()
  end;

  @vtest "Testing Board Mark" let
    B = Board(Set{Int}(),Set{Int}())
    A = TicTac.mark('C',3,B)
    A.comp == Set([3]) && B.comp == Set{Int}() &&
    A.human == Set{Int}() && B.human == Set{Int}() 
  end;
)

testsuite(tests)

