module TicTac

using Lazy
export Cube, Board, z, show, oob, moveDir, winSets, Board, mark

n = 4
allCells = Set(1:n^3)

immutable Cube
  r
  c
  l
  z
  Cube(r,c,l) = new(r,c,l,(l-1)*n*n + (r-1)*n + c) # This happens only at instantiation
end # of type Cube

# Methods for Cube
show(C::Cube) = println(string("(",C.r,",",C.c,",",C.l,")"))
oob(C::Cube) = C.r<1 || C.r>n || C.c<1 || C.c>n || C.l<1 || C.l>n
moveDir(C::Cube, dir) = Cube(C.r+dir[1],C.c+dir[2],C.l+dir[3])

lst = (-1,0,1)
dirs_000 = collect([(i::Int,j::Int,k::Int) for i in lst, j in lst, k in lst])
dirs = filter(x -> x != (0,0,0), dirs_000)
coord = collect(1:n)
function build(start::Cube, dir)
  @bounce function loop(s::Cube, S::Set{Cube})
    if (length(S) == n && !oob(s)) 
      S
    else
      dest = moveDir(s,dir)
      newS = Set([collect(S);dest])
      if (oob(dest) || length(newS)>n) 
        Set()
      else 
        loop(dest,newS)
      end
    end
  end
  loop(start,Set([start]))
end

winSets_tmp = [map(x -> Int(x.z), build(Cube(i,j,k), d))
  for i in coord, j in coord, k in coord, d in dirs]

winSets = Set(map(y -> Set{Int}(collect(y)), filter(x -> x != Any[], collect(winSets_tmp)) ))


immutable Board
  comp::Set{Int}
  human::Set{Int}
  Board(comp,human) = new(comp,human)
end
emptyCells(B::Board) = setdiff(allCells, union(B.comp,B.human))

function mark(player::Char, pos::Int, B::Board)
  player == 'C'? Board( Set{Int}(union(B.comp,pos)) ,B.human) : 
    Board(B.comp, Set{Int}(union(B.human,pos)) )
end

end # end of module Board
