module Psa.Util where

import Prelude

import Control.Monad.Rec.Class (class MonadRec)
import Data.Array (foldRecM)
import Data.String as Str

replicate :: forall m. (Monoid m) => Int -> m -> m
replicate n m = go n mempty where
  go i x
    | i <= 0    = x
    | otherwise = go (i - 1) (x <> m)

padLeft :: Int -> String -> String
padLeft width str = replicate (width - Str.length str) " " <> str

padRight :: Int -> String -> String
padRight width str = str <> replicate (width - Str.length str) " "

iter_ :: forall m a b. MonadRec m => Array a -> (Int -> a -> m b) -> m Unit
iter_ xs f = void $ foldRecM go 0 xs where
  go i a = (pure $ i + 1) <* f i a
    
