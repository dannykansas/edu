-- learn.hs

module Learn where
-- Declare the name of the module so that
-- it can be imported by name in a project.
-- Module names are always capitalized

x = 10 * 5 + y

myResult = x * 5

-- Because GHC loads the module in entirety,
-- we can define values of vars that functions  
-- rely on even after the function has been declared.
y = 10
