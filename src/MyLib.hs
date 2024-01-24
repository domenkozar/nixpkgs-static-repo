{-# LANGUAGE QuasiQuotes #-}
module MyLib (someFunc) where

import Text.RawString.QQ

someFunc :: IO ()
someFunc = putStrLn [r|
    Hello, world!
    This is a multi-line string.
    It's pretty cool.
|]
