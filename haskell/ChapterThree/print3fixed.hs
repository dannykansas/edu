-- print3fixed.hs
module Print3Fixed where

greeting :: String
greeting = "Yarrrr"

printSecond :: IO ()
printSecond = do
  putStrLn greeting

main :: IO ()
main = do
  putStrLn greeting
  printSecond
