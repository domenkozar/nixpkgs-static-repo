{-# LANGUAGE QuasiQuotes, OverloadedStrings #-}
module Main (main) where

import Text.RawString.QQ
import Database.Sqlite.Easy 
import Control.Monad (void)
import Data.Version (showVersion)
import Paths_myprogram (version)

main :: IO ()
main = void $ do
  print $ showVersion version
  withDb ":memory:" $ run [r|CREATE TABLE foo (bar TEXT)|]