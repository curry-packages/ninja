-- An example of a simple Ninja file description and its pretty printing

import Ninja.Pretty
import Ninja.Types

testdoc :: File
testdoc = File
  [ Var ("ninja_required_version", "1.1")
  , Rule "cc"
    [ ("depfile", "$out.d")
    , ("command", "gcc -MMD -MF $out.d [other gcc flags here]")]
  , Edge "cc" ["main.o"]
              []
              ["main.c","maina.c","mainb.c"]
              ["mainc.c"]
              ["maind.c"]
              [("extraopt", "value")]
  , Default "main.o"
  , Pool "heavy_pool" [("depth", "1")]]


main :: IO ()
main = putStrLn $ renderNinja testdoc
