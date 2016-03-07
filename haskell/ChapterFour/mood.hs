-- mood.hs

data Mood = Blah | Woot deriving Show
changeMood :: Mood -> Mood
changeMood Mood = Woot
changeMood Mood = Blah
