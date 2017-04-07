module Explorer.I18n.EN where

import Explorer.I18n.Types (Translation)

translation :: Translation
translation =
    { common:
        { cBack: "Back"
        , cApi: "Api"
        , cDocumentation: "Documentation"
        , cGithub: "Github"
        , cLinkedin: "Linkedin"
        , cTwitter: "Twitter"
        , cDaedalusWallet: "Daedalus Wallet"
        , cWhyCardano: "Why Cardano"
        , cCardanoRoadmap: "Cardano Roadmap"
        , cCardanoADAFaucet: "Cardano ADA Faucet"
        , cCardanoSLDocumentation: "Cardano SL Documentation"
        , cADA: "ADA"
        , cBCshort: "BC"
        , cBCong: "Bitcoin"
        , cTransaction: "Transaction"
        , cTransactions: "Transactions"
        , cTransactionFeed: "Transactions Feed"
        , cAddress: "Address"
        , cVersion: "version"
        , cCalculator: "Calculator"
        , cNetwork: "Network"
        , cSummary: "Summary"
        , cBlock: "Slot"
        , cHash: "Hash"
        , cHashes: "Hashes"
        , cEpoch: "Epoch"
        , cEpochs: "Epochs"
        , cSlot: "Slot"
        , cSlots: "Slots"
        , cAge: "Since"
        , cTotalSent: "Total Sent"
        , cRelayedBy: "Slot leader"
        , cSizeKB: "Size (kB)"
        , cExpand: "Expand"
        , cCollapse: "Collapse"
        , cNoData: "No data"
        , cCopyright: "Cardano Blockchain Explorer @2017"
        , cUnknown: "Unknown"
        , cTotalOutput: "Total Output"
        , cOf: "of"
        , cNotAvailable: "not available"
        , cLoading: "Loading..."
        , cDays: "Days"
        , cHours: "Hours"
        , cMinutes: "Minutes"
        , cSeconds: "Seconds"
        , cDateFormat: "MM/DD/YYYY HH:mm:ss"
        }
    , navigation:
        { navHome: "Home"
        , navBlockchain: "Blockchain"
        , navMarket: "Market"
        , navCharts: "Charts"
        , navTools: "Tools"
        }
    , hero:
        { hrTitle: "Cardano Blockchain Explorer"
        , hrSubtitle: "most effective way to reasearch crypto currencies network"
        , hrSearch: "Search for addresses, transactions, slots and epochs"
        }
    , dashboard:
        { dbLastBlocks: "Last slots"
        , dbLastBlocksDescription: "On {0} {1} transactions are generated"
        , dbPriceAverage: "Price (average)"
        , dbPriceForOne: "{0} for 1 {1}"
        , dbPriceSince: "{0} since yesterday."
        , dbTotalSupply: "Total supply"
        , dbTotalAmountOf: "Amount of {0} in the system."
        , dbTotalAmountOfTransactions: "Total amount of transactions detected in system since the beginning."
        , dbExploreBlocks: "Explore slots"
        , dbExploreTransactions: "Explore transactions"
        , dbBlockchainOffer: "What do we offer on our block explorer"
        , dbBlockSearch: "Slot search"
        , dbBlockSearchDescription: "Slot is a box where transactions are stored."
        , dbAddressSearch: "Address search"
        , dbAddressSearchDescription: "Address search"
        , dbTransactionSearch: "Transaction search"
        , dbTransactionSearchDescription: "Transaction is a transfer of coins from user 'A' to user 'B'."
        , dbApiDescription: "Our robust API is available in a variety of languages & SDKs."
        , dbGetAddress: "Get Address"
        , dbResponse: "Response"
        , dbCurl: "Curl"
        , dbNode: "Node"
        , dbJQuery: "jQuery"
        , dbGetApiKey: "Get API key"
        , dbMoreExamples: "See more examples"
        , dbAboutBlockchain: "About Blockchain"
        , dbAboutBlockchainDescription: "Blockchain API makes it easy yo build cryptocurrensies applications and features. We are focused on providing a platform that enables developers to create fast, scalable, secure services.<br/><br/>This API is free and unlimited while we are in beta. We are just getting started, and will be rolling out more endpoints and features in the coming weeks. We want to build the API you need, so please send us requests, suggestions, or just say hello."
        }
    , address:
        { addScan: "Scan this QR Code to copy address to clipboard"
        , addQrCode: "QR-Code"
        , addFinalBalance: "Final balance"
        , addNotFound: "Address does not exist."
        }
    , tx:
        { txTime: "Received time"
        , txIncluded: "Included In Slots"
        , txRelayed: "Relayed by IP"
        , txEmpty: "No transactions"
        , txNotFound: "Transaction does not exist."
        }
    , block:
        { blFees: "Fees"
        , blEstVolume: "Est. Volume"
        , blPrevBlock: "Previous slot"
        , blNextBlock: "Next slot"
        , blRoot: "Merkle root"
        , blNotFound: "Epoch / slot do not exist."
        }
    , footer:
        { fooRessources: "Ressources"
        , fooFollow: "Follow us"
        , fooLinks: "Links"
        , fooIohkSupportP: "IOHK supported project"
        }
    , notfound:
        { nfTitle: "404"
        , nfDescription: "Page not found"
        , nfBack2Dashboard: "Back to Dashboard"
        }
    }
