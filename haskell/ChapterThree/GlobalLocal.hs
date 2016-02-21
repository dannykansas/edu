-- GlobalLocal.hs
module GlobalLocal where

topLevelValue :: Integer
topLevelValue = 5

topLevelFunction :: Integer -> Integer
topLevelFunction x = x + woot + topLevelValue
  where woot :: Integer
        woot = 10

-- `woot` is defined in a where clause meaning that it is a local binding
-- `let` also creates local bindings and declarations

-- also note that `woot` explicitly was given a Type definition, even though
-- this wasn't totally necesary as Haskell has Type inference which would have
-- figured it out.
