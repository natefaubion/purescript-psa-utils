module Test.Main where

import Prelude

import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode (decodeJson, printJsonDecodeError)
import Data.Argonaut.Parser (jsonParser)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Psa (PsaResult, encodePsaResult, parsePsaResult)

foreign import assert :: String -> Boolean -> Effect Unit

main :: Effect Unit
main = do
  let
    -- Literal compiler output
    output = """{"warnings":[],"errors":[{"position":{"startLine":5,"startColumn":9,"endLine":5,"endColumn":15},"message":"  Unknown type Effect\n","errorCode":"UnknownName","errorLink":"https://github.com/purescript/documentation/blob/master/errors/UnknownName.md","filename":"test/Main.purs","moduleName":"Test.Main","suggestion":null,"allSpans":[{"end":[5,15],"name":"test/Main.purs","start":[5,9]}]}]}"""
    parse s = jsonParser s >>= (lmap printJsonDecodeError <<< decodeJson) >>= parsePsaResult

    -- Manually mangled from output json
    result :: PsaResult
    result =
      { warnings: []
      , errors:
          [ { position: Just { startLine: 5, startColumn: 9, endLine: 5, endColumn: 15 }
            , message: "  Unknown type Effect\n"
            , errorCode: "UnknownName"
            , errorLink: "https://github.com/purescript/documentation/blob/master/errors/UnknownName.md"
            , filename: Just "test/Main.purs"
            , moduleName: Just "Test.Main"
            , suggestion: Nothing
            , allSpans: [ { start: { line: 5, column: 9 }, end: { line: 5, column: 15 }, name: "test/Main.purs" } ]
            }
          ]
      }

  assert "Parse simple error" $ parse output == Right result

  assert "Round trips" $ Right result == (parse $ stringify $ encodePsaResult result)