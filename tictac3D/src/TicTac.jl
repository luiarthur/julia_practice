module TicTac

using Lazy
export Cube, Board, z, show, oob, moveDir, winSets, Board, mark,
       toString, win, lose, draw, inProg, winner, randomGame, randMove, winGame,
       probWin, smartMove

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
  #@bounce function loop(s::Cube, S::Set{Cube})
  function loop(s::Cube, S::Set{Cube})
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

function toString(B::Board)
  out = ""
  for k = 1:n
    for j = 1:n
      q = ""
      out = string(out, "  ")
      for i = 1:n
        ind = i+n*(j-1)+n*n*(k-1)
        p = in(ind, B.comp)? "C" : in(ind, B.human)? "H" : "_"
        q = ind < 10 ? string(q,"  ") : string(q," ")
        q = string(q, ind, " ")
        out = string(out, p)
      end
      out = string(out, "  |  ", q, "\n")
    end
    out = string(out,"\n")
  end
  out
end

function win(player::Char,B::Board)
  p = player == 'C'? B.comp : B.human
  sum([w <= p for w in winSets]) > 0
end
opp(player::Char) = player == 'C'? 'H' : 'C'
lose(player::Char, B::Board) = win(opp(player),B)
draw(B::Board) = emptyCells(B) == Set{Int}() && !win('C',B) && !win('H',B)
inProg(B::Board) = length(emptyCells(B))>0 && !win('C',B) && !win('H',B)
function winner(B::Board)
  if !draw(B)
    win('C',B)? 'C' : 'H'
  else
    'D'
  end
end

randMove(player::Char, B::Board) = mark(player, rand(collect(emptyCells(B))), B)

function randomGame(player::Char, B::Board)
  if inProg(B)
    randomGame(opp(player),randMove(player,B))
  else
    B
  end
end

winGame(player::Char, B::Board) = winner(B)==player||draw(B)? 1 : 0

probWin(player::Char, pos::Int, N::Int,B::Board) = 
  mean(map(x -> winGame(player,randomGame(opp(player),mark(player,pos,B))), 1:N))

# This is where I stop. This move takes 4 minutes (on my 8 core machine)
# with an Empty Board. Perhaps this would be faster if multithreading were
# possible. But, even if I changed the line below to pmap, the
# overhead for threading is too great. So, I think I will stick
# wtih Scala as my new language of choice. It's hip, fun, fast, 
# and concise. Julia is only good for linear algebra. Definitely
# not for general purpose. It's a great replacement for Matlab 
# for sure. But not other general purpose languages for general
# purpose work. The end. Goodbye Julia!
function smartMove(player::Char,N::Int,B::Board)
  cells = emptyCells(B)
  probs = map(x -> probWin(player,x,N,B), cells)
  maxprob,pos = findmax(probs)
  println("Computer's Prob of Random Win: ",maxprob)
  pos
end

end # end of module Board
