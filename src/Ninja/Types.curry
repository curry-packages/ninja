--- Module to represent the structure of Ninja build files
--- @author Marc Andre Wittorf

module Ninja.Types(
  File(..), Decl(..),
  Def, Target, RuleName
) where

-- This tries to be as close as possible to Ninja file reference
-- https://ninja-build.org/manual.html#_Ninja_file_reference
-- Also names are, if possible, taken or derived from those notations

--- A Ninja file
data File = File [Decl]

--- A Ninja declaration
--- @cons Rule     a build rule
--- @cons Edge     a build edge
--- @cons Var      a global variable definition
--- @cons Default  a default edge specification
--- @cons Subninja a subninja directive
--- @cons Include  an include directive
--- @cons Pool     a pool section
data Decl
  = Rule RuleName -- name
         [Def]    -- variable definitions
  | Edge RuleName -- rule name
         [Target] -- outputs
         [Target] -- implicit outputs
         [Target] -- dependencies
         [Target] -- implicit dependencies
         [Target] -- order only dependencies
         [Def]    -- variable definitions for this build
  | Var Def
  | Default Target
  | Subninja FilePath
  | Include FilePath
  | Pool String
         [Def]

--- A Ninja definition (variable, value)
type Def = (String, String)

--- A Ninja target
type Target = String

--- A Ninja rule name
type RuleName = String
