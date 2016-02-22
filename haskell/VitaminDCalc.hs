-- VitaminDCalc.hs

-- Calculator derived from the following equation:
-- Dose = [(8.52 − Desired change in serum 25-hydroxyvitamin D level) 
--      + (0.074 × Age) 
--      – (0.20 × BMI)
--      + (1.74 × Albumin concentration) 
--      – (0.62 × Starting serum 25-hydroxyvitamin D concentration)]/(−0.002)

module VitaminCalc where

userGoal    :: Integer
userAge     :: Integer
userBMI     :: Float
userAlb     :: Integer
userStart   :: Integer

main :: IO ()
main userGoal userAge userBMI userAlb user Start = 


