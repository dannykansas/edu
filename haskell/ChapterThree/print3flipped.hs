-- print3flipped.hs
module Print3Flipped where

myGreeting :: String
myGreeting = (++) "hello" " cruel world!"

hello :: String
hello = "hello"

world :: String
world = "cruel world!"

main :: IO ()
main = do
  putStrLn myGreeting
  putStrLn secondGreeting
  where secondGreeting = (++) hello ((++) " " world)
  -- could've been: secondGreeting = hello ++ " " ++ world, also
