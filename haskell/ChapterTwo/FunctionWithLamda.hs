-- FunctionWithLambda.hs

printInc2 n = let plusTwo = n + 2
              in print plusTwo

-- turns into 

printInc2' n =
  (\plusTwo -> print plusTwo) (n + 2)
