{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module Network.AWS.S3 where

import Control.Monad.Eff
import Data.String
import Data.Foreign

import Network.AWS.Types

foreign import s3
  """
  function s3(opts) {
    return new (require('aws-sdk')).S3(opts);
  }
  """
  :: forall a. {region :: String | a} -> S3

foreign import listBuckets
  """
  function listBuckets(s3) {
    return s3.listBuckets();
  }
  """
  :: S3 -> Request

foreign import createBucket
  """
  function createBucket(s3) {
    return function(params) {
      return function(callback) {
        return function() {
          s3.createBucket(params, callback);
        }
      }
    }
  }
  """
  :: forall r e1 e2.
     S3
  -> {"Bucket" :: String | r}
  -> AwsCallback e1
  -> AwsEff e2 Unit

foreign import headBucket
  """
  function headBucket(s3) {
    return function(params) {
      return function(callback) {
        return function() {
          s3.headBucket(params, callback);
        }
      }
    }
  }
  """
  :: forall r e1 e2.
     S3
  -> {"Bucket" :: String | r}
  -> AwsCallback e1
  -> AwsEff e2 Unit

foreign import getBucketLocation
  """
  function getBucketLocation(s3) {
    return function(params) {
      return function(callback) {
        return function() {
          s3.getBucketLocation(params, callback);
        }
      }
    }
  }
  """
  :: forall r e1 e2.
     S3
  -> {"Bucket" :: String | r}
  -> AwsCallback e1
  -> AwsEff e2 Unit

foreign import getBucketLogging
  """
  function getBucketLogging(s3) {
    return function(params) {
      return function(callback) {
        return function() {
          s3.getBucketLogging(params, callback);
        }
      }
    }
  }
  """
  :: forall r e1 e2.
     S3
  -> {"Bucket" :: String | r}
  -> AwsCallback e1
  -> AwsEff e2 Unit

foreign import putBucketLogging
  """
  function putBucketLogging(s3) {
    return function(params) {
      return function(callback) {
        return function() {
          s3.putBucketLogging(params, callback);
        }
      }
    }
  }
  """
  :: forall r1 r2 r3 e1 e2.
     S3
  -> { "Bucket" :: String
     , "BucketLoggingStatus" ::
        { "LoggingEnabled" :: { "TargetBucket" :: String
                              , "TargetGrants" :: [{ | r1}]
                              , "TargetPrefix" :: String
                              | r2 } }
     | r3 }
  -> AwsCallback e1
  -> AwsEff e2 Unit

foreign import listObjects
  """
  function listObjects(s3) {
    return function(params) {
      return s3.listObjects(params);
    }
  }
  """
  :: forall e. S3 -> {"Bucket" :: String} -> Request
