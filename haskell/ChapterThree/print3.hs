-- print3.hs
module Print3 where

myGreeting :: String
-- The aboe line reads as: "myGreeting function has the type String"
myGreeting = "hello" ++ " cruel world!"
-- Could also be: "hello cruel" ++ " " ++ "world!"
-- to obtain the same result

hello :: String
hello = "Hello"

world :: String
world = "cruel world!"

main :: IO ()
main = do
  putStrLn myGreeting
  putStrLn secondGreeting
  where secondGreeting = concat [hello, " ", world]

-- Note a couple things: myGreeting is defined in the global scope
-- We specify explicit types for top level definitions (`myGreeting`, `hello`,
-- `world`, and `main`)

-- We also can concatenate with either `++` or `concat`
