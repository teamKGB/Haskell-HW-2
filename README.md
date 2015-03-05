# Haskell homework

<b>Deadline:</b> Thu. March 12 at noon.

The (usual) lambda terms are defined as the data type:

data Term = Var Int | Lam Int Term | App Term Term deriving (Eq, Show, Read)

where variables are represented as integers. A term is called closed if
for every i in Var i there's a term of the from Lam i <subterm> on the path
from it to the root, providing it a binding.

De Bruijn terms are defined as the data type:

data BTerm =BVar Int | BLam BTerm | BApp BTerm BTerm deriving (Eq, Show, Read)

Write a Haskell function db2lam that transforms a de Bruijn term into a lambda term.
Write a Haskell function lam2db that transforms a lambda term into a Bruijn term.

Write a function isClosed that tests if a lambda term is closed.
Write a function isClosed that tests if a de Bruijn term is closed.

Chose one of the following two subjects:

a) Implement normal order beta reduction for de Bruijn terms<br>
b) Implement normal order beta reduction for (the usual) lambda terms
 
