{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module Network.AWS where

import Control.Monad.Eff
import Data.String
import Data.Foreign

import Network.AWS.Types

foreign import awsCallback
  """
  function awsCallback(f) {
    return function(e, d) {
      return f(e)(d)();
    }
  }
  """
  :: forall a b e r. AwsFn a b e r -> AwsCallback e

foreign import send
  """
  function send() {
    return function(request) {
      return function(sFn) {
        return function(eFn) {
          return function(cFn) {
            return function() {
              return request.on('success', sFn)
                            .on('error', eFn)
                            .on('complete', cFn)
                            .send();
            }
          }
        }
      }
    }
  }
  """
  :: forall a e r.
     Request
  -> ({|a} -> AwsEff e r)    -- success  callback
  -> ({|a} -> AwsEff e Unit) -- error    callback
  -> AwsEff e Unit           -- complete callback
  -> AwsEff e Unit

foreign import eachItem
  """
  function eachItem(request) {
    return function(callback) {
      return function() {
        request.eachItem(callback);
      }
    }
  }
  """
  :: forall r e1 e2. Request -> AwsCallback e1 -> AwsEff e2 r
