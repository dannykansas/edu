-- TestWhere.hs
-- 2.12 Exercise let to where translation
func1     = x * 3 + y 
  where x = 3
        y = 1000

func2     = x * 5
  where y = 10
        x = 10 * 5 + y

func3     = z / x + y
  where x = 7
        y = negate x
        z = y * 10
