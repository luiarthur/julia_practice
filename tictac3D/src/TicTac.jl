module TicTac

using Lazy
export Cube, Board, z

n = 4
allCells = 1:n^3

immutable Cube
  r
  c
  l
  z
  Cube(r,c,l) = new(r,c,l,(l-1)*n*n + (r-1)*n + c) # This happens only at instantiation
end # of type Cube

show(C::Cube) = println(C.r,C.c,C.l,C.z)


end # end of module Board
