{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module Network.AWS.Types where

import Control.Monad.Eff

foreign import data AWS :: !

foreign import data EC2 :: *
foreign import data IAM :: *
foreign import data RDS :: *
foreign import data S3  :: *

foreign import data Request :: *

type WithAWS e = Eff (aws :: AWS | e)

type AwsFn a b e r = a -> b -> WithAWS e r

foreign import data AwsCallback :: # ! -> *

type EC2Region =
  forall a. { "Endpoint"   :: String
            , "RegionName" :: String | a }

type EC2Volume =
  forall a. { "Size"       :: Number
            , "State"      :: String
            , "VolumeId"   :: String | a }

type EC2Snapshot =
  forall a. { "SnapshotId" :: String
            , "State"      :: String
            , "VolumeSize" :: Number
            , "VolumeId"   :: String | a }
