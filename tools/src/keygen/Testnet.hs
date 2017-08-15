module Testnet
       ( generateKeyfile
       , generateFakeAvvm
       , genTestnetDistribution
       , rearrangeKeyfile
       ) where

import           Universum

import           Control.Lens          ((?~))
import qualified Serokell.Util.Base64  as B64
import           Serokell.Util.Verify  (VerificationRes (..), formatAllErrors,
                                        verifyGeneric)
import           System.Random         (randomRIO)
import           System.Wlog           (WithLogger)

import           Pos.Binary            (asBinary)
import qualified Pos.Constants         as Const
import           Pos.Core              (IsBootstrapEraAddr (..), deriveLvl2KeyPair)
import           Pos.Crypto            (EncryptedSecretKey, PublicKey, RedeemPublicKey,
                                        SecretKey, emptyPassphrase, keyGen, noPassEncrypt,
                                        redeemDeterministicKeyGen, safeKeyGen,
                                        secureRandomBS, toPublic, toVssPublicKey,
                                        vssKeyGen)
import           Pos.Genesis           (StakeDistribution (..), accountGenesisIndex,
                                        wAddressGenesisIndex)
import           Pos.Ssc.GodTossing    (VssCertificate, mkVssCertificate)
import           Pos.Types             (Address, coinPortionToDouble, unsafeIntegerToCoin)
import           Pos.Util.UserSecret   (initializeUserSecret, takeUserSecret,
                                        usPrimKey, usVss, usWallets,
                                        writeUserSecretRelease)
import           Pos.Wallet.Web.Secret (mkGenesisWalletUserSecret)

import           KeygenOptions         (TestStakeOptions (..))

rearrangeKeyfile :: (MonadIO m, MonadFail m, WithLogger m) => FilePath -> m ()
rearrangeKeyfile fp = do
    us <- takeUserSecret fp
    let sk = maybeToList $ us ^. usPrimKey
    writeUserSecretRelease $
        -- AJ: TODO: Not certain if this is correct. Most probably `rearrange` doesn't make sense anymore
        us & usWallets %~ (++ map (mkGenesisWalletUserSecret . noPassEncrypt) sk)

generateKeyfile
    :: (MonadIO m, MonadFail m, WithLogger m)
    => Bool
    -> Maybe (SecretKey, EncryptedSecretKey)  -- ^ plain key & hd wallet root key
    -> FilePath
    -> m (PublicKey, VssCertificate, Address)  -- ^ plain key, certificate & hd wallet
                                               -- account address with bootstrap era distribution
generateKeyfile isPrim mbSk fp = do
    initializeUserSecret fp
    (sk, hdwSk) <- case mbSk of
        Just x  -> return x
        -- AJ: TODO: Why do we use unrelated sk and hdwSk? Why not `hdwSk = noPassEncrypt sd`. safeKeyGen effectively does noPassEncrypt.
        Nothing -> (,) <$> (snd <$> keyGen) <*> (snd <$> safeKeyGen emptyPassphrase)
    vss <- vssKeyGen
    us <- takeUserSecret fp

    writeUserSecretRelease $
        us & (if isPrim
              then usPrimKey .~ Just sk
              -- AJ: TODO: Again, this is most probably wrong.
              else usWallets %~ (++ [mkGenesisWalletUserSecret hdwSk]))
           & usVss .~ Just vss

    expiry <- liftIO $
        fromIntegral <$>
        randomRIO @Int (Const.vssMinTTL - 1, Const.vssMaxTTL - 1)
    let vssPk = asBinary $ toVssPublicKey vss
        vssCert = mkVssCertificate sk vssPk expiry
        -- This address is used only to create genesis data. We don't
        -- put it into a keyfile.
        hdwAccountPk =
            fst $ fromMaybe (error "generateKeyfile: pass mismatch") $
            deriveLvl2KeyPair (IsBootstrapEraAddr True) emptyPassphrase hdwSk
                accountGenesisIndex wAddressGenesisIndex
    return (toPublic sk, vssCert, hdwAccountPk)

generateFakeAvvm :: MonadIO m => FilePath -> m RedeemPublicKey
generateFakeAvvm fp = do
    seed <- secureRandomBS 32
    let (pk, _) = fromMaybe
            (error "cardano-keygen: impossible - seed is not 32 bytes long") $
            redeemDeterministicKeyGen seed
    writeFile fp $ B64.encode seed
    return pk

-- | Generates stake distribution for testnet.
genTestnetDistribution :: TestStakeOptions -> StakeDistribution
genTestnetDistribution TestStakeOptions{..} =
    checkConsistency $ RichPoorStakes {..}
  where
    richs = fromIntegral tsoRichmen
    poors = fromIntegral tsoPoors * 2  -- for plain and hd wallet keys
    testStake = fromIntegral tsoTotalStake

    -- Calculate actual stakes
    desiredRichStake = getShare tsoRichmenShare testStake
    oneRichmanStake = desiredRichStake `div` richs +
        if desiredRichStake `mod` richs > 0 then 1 else 0
    realRichStake = oneRichmanStake * richs
    poorsStake = testStake - realRichStake
    onePoorStake = poorsStake `div` poors
    realPoorStake = onePoorStake * poors

    mpcStake = getShare (coinPortionToDouble Const.genesisMpcThd) testStake

    sdRichmen = fromInteger richs
    sdRichStake = unsafeIntegerToCoin oneRichmanStake
    sdPoor = fromInteger poors
    sdPoorStake = unsafeIntegerToCoin onePoorStake

    -- Consistency checks
    everythingIsConsistent :: [(Bool, Text)]
    everythingIsConsistent =
        [ ( realRichStake + realPoorStake <= testStake
          , "Real rich + poor stake is more than desired."
          )
        , ( oneRichmanStake >= mpcStake
          , "Richman's stake is less than MPC threshold"
          )
        , ( onePoorStake < mpcStake
          , "Poor's stake is more than MPC threshold"
          )
        ]

    checkConsistency :: a -> a
    checkConsistency = case verifyGeneric everythingIsConsistent of
        VerSuccess        -> identity
        VerFailure errors -> error $ formatAllErrors errors

    getShare :: Double -> Integer -> Integer
    getShare sh n = round $ sh * fromInteger n
