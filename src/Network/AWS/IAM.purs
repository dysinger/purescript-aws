{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module Network.AWS.IAM where

import Control.Monad.Eff
import Data.String
import Data.Foreign
import Network.AWS.Types

foreign import iam
  """
  function iam(opts) {
    return new (require('aws-sdk')).IAM(opts);
  }
  """
  :: forall a. {region :: String | a} -> IAM

foreign import getUser
  """
  function getUser(iam) {
    return function(params) {
      return function(callback) {
        return function() {
          iam.getUser(params, callback);
        }
      }
    }
  }
  """
  :: forall a e. IAM -> {|a} -> AwsCallback e -> WithAWS e Unit

iamUserAccountId :: forall r. { "Arn" :: String | r } -> String
iamUserAccountId { "Arn" = arn } = acctId $ split ":" arn
  where acctId ("arn":"aws":"iam":_:i:_) = i
