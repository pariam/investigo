--------------------------------------------------------------------
-- |
-- Copyright :  (c) 2017 Ricky Elrod
-- License   :  BSD3
-- Maintainer:  Ricky Elrod <ricky@elrod.me>
-- Stability :  experimental
-- Portability: non-portable
--
-- This module provides utility functions for dealing with clients which request
-- a compact representation of the peer list.
--------------------------------------------------------------------
module Pariam.Investigo.Compact where

import qualified Data.ByteString.Builder as B
import qualified Data.ByteString.Lazy as B
import Data.IP hiding (ipv4)
import Network.Socket (hostAddressToTuple)
import Text.Read (readMaybe)

ipAndPortToByteString :: String -> Integer -> Maybe B.ByteString
ipAndPortToByteString ip port = do
  ipv4 <- readMaybe ip :: Maybe IPv4
  let (a,b,c,d) = hostAddressToTuple . toHostAddress $ ipv4
      ipBS = B.pack [a, b, c, d]
      portBS = B.toLazyByteString . B.word16BE . fromIntegral $ port
  return (B.append ipBS portBS)
