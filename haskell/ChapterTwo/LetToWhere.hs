-- LetToWhere.hs

-- a simple function multiplying defined integers by each other
-- along with an input from IO()
mult1 z     = x * y * z
    where x = 5
          y = 6


-- And, mult1' shows this in let/in notation 
mult1' z    = let x = 5; y = 6
              in x * y * z

-- More practice...
mult2 test  = x * (y^test)
    where x = 6
          y = 20

-- And, mult2' shows mult2 in let/in notation
mult2' test = let x = 6; y = 20
              in x * (y^test)
