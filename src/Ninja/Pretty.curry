--- Module to pretty print Ninja build files
--- @author Marc Andre Wittorf
--- @version 0.1

module Ninja.Pretty(
  renderNinja, ppFile,
  ppDecl, ppDef, ppDefs, ppTargets, ppImplicitTargets, ppOrderOnlyTargets
) where

import Text.Pretty

import Ninja.Types


--- Render a Ninja file to a string representation
--- @param file the abstract Ninja file representation
--- @return     the rendered Ninja file
renderNinja :: File -> String
renderNinja = showWidth 15 . ppFile

--- Render a Ninja file to a Pretty-Doc
--- @param file the abstract Ninja file representation
--- @return     the rendered Ninja file
ppFile :: File -> Doc
ppFile (File decls) = (vsepBlank $ map ppDecl decls) <> hardline

--- Render a Ninja declaration
--- @param decl a Ninja declaration
--- @param      the rendered Ninja declaration
ppDecl :: Decl -> Doc
ppDecl (Rule n ds)                     = nest 2 $ text "rule" <+> text n $$
                                                  ppDefs ds
ppDecl (Edge r eos ios eis iis ois ds) = nest 2 $
                                         text "build" <+>
                                         ppTargets eos <+>
                                         ppImplicitTargets ios <>
                                         colon <+>
                                         text r <+>
                                         ppTargets eis <+>
                                         ppImplicitTargets iis <+>
                                         ppOrderOnlyTargets ois $$ ppDefs ds
ppDecl (Var d)                         = ppDef d
ppDecl (Default t)                     = text "default" <+> text t
ppDecl (Subninja p)                    = text "subninja" <+> text p
ppDecl (Include p)                     = text "include" <+> text p
ppDecl (Pool n ds)                     = nest 2 $ text "pool" <+> text n $$
                                                  ppDefs ds


--- Render a defintion
--- @param def the definition
--- @return    the rendered definition
ppDef :: Def -> Doc
ppDef (k,v) = text k <+> equals <+> text v

--- Render definitions
--- @param defs the definitions
--- @return     the rendered definitions
ppDefs :: [Def] -> Doc
ppDefs = vsep . map ppDef

--- Render explicit targets
--- @param tgts the targets
--- @return     the rendered targets
ppTargets :: [Target] -> Doc
ppTargets = hsep . map (text . escapeFilenames)

--- Render implicit targets
--- @param tgts the targets
--- @return     the rendered targets
ppImplicitTargets :: [Target] -> Doc
ppImplicitTargets []       = empty
ppImplicitTargets ts@(_:_) = char '|' <+> ppTargets ts

--- Render order-only targets
--- @param tgts the targets
--- @return     the rendered targets
ppOrderOnlyTargets :: [Target] -> Doc
ppOrderOnlyTargets []       = empty
ppOrderOnlyTargets ts@(_:_) = text "||" <+> ppTargets ts

--- Escape filenames (replace spaces, dollars, line breaks and colons)
--- @param tgt a target
--- @return    the escaped target
escapeFilenames :: Target -> Target
escapeFilenames = concatMap $ \c -> case c of
                                         ' '  -> "$ "
                                         '$'  -> "$$"
                                         '\n' -> "$\n"
                                         ':'  -> "$:"
                                         _    -> [c]

-- -----------------------------------------------------------------------------
