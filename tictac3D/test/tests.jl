using TestSuite

tests = :(
  @vtest "This is a stupid test for 1 == 1" 1==1;
  @vtest "This is a stupid test for 2 != 1" 2!=1;
  @vtest "This is a stupid test for 2 != 1" 2==1;
  @vtest "This is a stupid test for 2 != 1" a==b;
)

testsuite(tests)
