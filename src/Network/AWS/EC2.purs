{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module Network.AWS.EC2 where

import Control.Monad.Eff
import Data.String
import Data.Foreign

import Network.AWS.Types

foreign import ec2
  """
  function ec2(opts) {
    return new (require('aws-sdk')).EC2(opts);
  }
  """
  :: forall a. {region :: String | a} -> EC2

foreign import ec2Regions
  """
  function ec2Regions(ec2) {
    return ec2.describeRegions();
  }
  """
  :: EC2 -> Request

foreign import ec2Addresses
  """
  function ec2Addresses(ec2) {
    return ec2.describeAddresses();
  }
  """
  :: EC2 -> Request

foreign import ec2Images
  """
  function ec2Images(ec2) {
    return function(params) {
      return ec2.describeImages(params);
    }
  }
  """
  :: forall a. EC2 -> {|a} -> Request

foreign import ec2KeyPairs
  """
  function ec2KeyPairs(ec2) {
    return ec2.describeKeyPairs();
  }
  """
  :: EC2 -> Request

foreign import ec2SecurityGroups
  """
  function ec2SecurityGroups(ec2) {
    return ec2.describeSecurityGroups();
  }
  """
  :: EC2 -> Request

foreign import ec2Instances
  """
  function ec2Instances(ec2) {
    return ec2.describeInstances();
  }
  """
  :: EC2 -> Request

foreign import ec2ReservedInstances
  """
  function ec2ReservedInstances(ec2) {
    return ec2.describeReservedInstances();
  }
  """
  :: EC2 -> Request

foreign import ec2Volumes
  """
  function ec2Volumes(ec2) {
    return ec2.describeVolumes();
  }
  """
  :: EC2 -> Request

foreign import ec2Snapshots
  """
  function ec2Snapshots(ec2) {
    return function(params) {
      return ec2.describeSnapshots(params);
    }
  }
  """
  :: forall a. EC2 -> {|a} -> Request

foreign import ec2DeleteSnapshot
  """
  function ec2DeleteSnapshot(ec2) {
    return function(params) {
      return function(callback) {
        return function() {
          ec2.deleteSnapshot(params, callback);
        }
      }
    }
  }
  """
  :: forall a e1 e2.
     EC2
  -> {"SnapshotId" :: String | a}
  -> AwsCallback e1
  -> AwsEff e2 Unit
