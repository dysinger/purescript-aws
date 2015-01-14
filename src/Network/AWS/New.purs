module Network.AWS.New where

import Control.Monad.Eff
import Control.Monad.Eff.Exception
import Data.Either
import Data.Function hiding (on)
import Data.Foreign (isNull, unsafeFromForeign)
import Data.Maybe
import Debug.Trace

{- Util -}

foreign import data Nullable :: * -> *

type JSCallback a = Fn2 (Nullable Error) a Unit

type Callback e a = Either Error a -> AwsEff e Unit

type LeftErr a = Error -> Either Error a

type RightData a = a -> Either Error a

foreign import handleImpl
  """
  function handleImpl(left, right, f) {
    return function(err, data) {
      if (err) f(left(err))();
      else f(right(data))();
    };
  }
  """
  :: forall e a. Fn3 (LeftErr a) (RightData a) (Callback e a) (JSCallback a)

handle :: forall e a b. (Callback e a) -> JSCallback a
handle cb = runFn3 handleImpl Left Right cb

foreign import mkEff
  "function mkEff(action) {\
  \  return action;\
  \}" :: forall e a. (Unit -> a) -> Eff e a

{- AWS -}

foreign import data AWS :: !

type AwsEff e = Eff (aws :: AWS | e)

{- SDK -}

type SDK          = { config :: SDKConfig }
type SDKConfig    = { update :: forall a e. Fn1 (SDKOptions a) Unit }
type SDKOptions a = {|a}

foreign import sdk "var sdk = require('aws-sdk');" :: SDK

configUpdate :: forall a e. SDK -> (SDKOptions a) -> AwsEff e Unit
configUpdate s p = mkEff $ \_ -> runFn1 s.config.update p

{- Request -}

type Request =
  { eachItem :: forall a e. Fn1 (JSCallback a) (AwsEff e Unit)
  , on       :: forall a e. Fn2 String (JSCallback a) (AwsEff e Unit)
  , send     :: forall e. Fn0 (AwsEff e Unit)
  }

eachItem r c = mkEff $ \_ -> runFn1 r.eachItem c
on r e c     = mkEff $ \_ -> runFn2 r.on e c
send r       = mkEff $ \_ -> runFn0 r.send

{- EC2 -}

type EC2 = { describeRegions           :: forall a. Fn1 (DescribeRegionsParams           a) Request
           , describeInstances         :: forall a. Fn1 (DescribeSecurityGroupsParams    a) Request
           , describeReservedInstances :: forall a. Fn1 (DescribeReservedInstancesParams a) Request
           }

type EC2Options a = {|a}

type DescribeRegionsParams           a = {|a}
type DescribeSecurityGroupsParams    a = {|a}
type DescribeReservedInstancesParams a = {|a}

type EC2Region =
  forall a. { "Endpoint"   :: String
            , "RegionName" :: String | a }

foreign import ec2
  """
  function ec2(sdk) {
    return function(opts) {
      return new sdk.EC2(opts)
    }
  };
  """
  :: forall a. SDK -> EC2Options a -> EC2

describeRegions           e p = runFn1 e.describeRegions           p
describeInstances         e p = runFn1 e.describeInstances         p
describeReservedInstances e p = runFn1 e.describeReservedInstances p

main = do
  let sdk' = sdk
  configUpdate sdk' { region: "us-west-1" }
  let ec2' = ec2 sdk' {}
      req = describeRegions ec2' {}
  eachItem req (handle showRegion)
  where
    showRegion (Left _) = print "oops"
    showRegion (Right x) | isNull x = print "done"
    showRegion (Right x) = do
      let x' = unsafeFromForeign x
      print (x'."RegionName" :: String)
