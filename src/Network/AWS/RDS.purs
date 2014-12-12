{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module Network.AWS.RDS where

import Control.Monad.Eff
import Data.String
import Data.Foreign

import Network.AWS.Types

foreign import rds
  """
  function rds(opts) {
    return new (require('aws-sdk')).RDS(opts);
  }
  """
  :: forall a. {region :: String | a} -> RDS

foreign import describeDBSecurityGroups
  """
  function describeDBSecurityGroups(rds) {
    return rds.describeDBSecurityGroups();
  }
  """
  :: RDS -> Request

foreign import describeDBInstances
  """
  function describeDBInstances(rds) {
    return rds.describeDBInstances();
  }
  """
  :: RDS -> Request

foreign import describeReservedDBInstances
  """
  function describeReservedDBInstances(rds) {
    return rds.describeReservedDBInstances();
  }
  """
  :: RDS -> Request

foreign import describeDBEvents
  """
  function describeDBEvents(rds) {
    return rds.describeEvents();
  }
  """
  :: RDS -> Request

foreign import describeDBSnapshots
  """
  function describeDBSnapshots(rds) {
    return function() {
      return rds.describeDBSnapshots();
    }
  }
  """
  :: RDS -> Request
