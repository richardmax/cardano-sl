module Explorer.View.Footer (footerView) where

import Prelude
import Data.Maybe (fromMaybe)
import Data.Lens ((^.))
import Explorer.I18n.Lang (Language(..), readLanguage, translate)
import Explorer.I18n.Lenses (common, cApi, footer, fooLinks, fooRessources, fooFollow, fooIohkSupportP, cDocumentation, cGithub, cLinkedin, cTwitter, cDaedalusWallet, cWhyCardano, cCardanoRoadmap, cCardanoADAFaucet, cCardanoSLDocumentation) as I18nL
import Explorer.State (initialState)
import Explorer.Lenses.State (lang)
import Explorer.Types.Actions (Action(..))
import Explorer.Types.State (State)
import Pux.Html (Html, div, text, nav, a, select, option, p, span) as P
import Pux.Html.Attributes (value, className, href, selected) as P
import Pux.Html.Events (onChange) as P


footerView :: State -> P.Html Action
footerView state =
    let lang' = state ^. lang in
    P.div [ P.className "explorer-footer" ]
    [
      P.div
          [ P.className "explorer-footer__top" ]
          [ P.div
              [ P.className "explorer-footer__container" ]
              [ P.nav
                  [ P.className "nav__container"]
                  [ navRowView $ resourcesNavRow lang'
                  , navRowView $ followUsNavRow lang'
                  , navRowView $ linksNavRow lang'
                  ]
              ]
          ]
      , P.div
          [ P.className "explorer-footer__bottom" ]
          [ P.div
              [ P.className "explorer-footer__container" ]
              [ P.div
                  [ P.className "content content__left" ]
                  [ P.div
                      [ P.className "logo__container"]
                      [ P.a
                          [ P.className "logo_name__img bg-logo-name"
                          , P.href "https://iohk.io/projects/cardano/"]
                          []
                      ]
                  , P.span
                      [ P.className "split" ]
                      []
                  , P.a
                      [ P.className "support", P.href "//iohk.io/projects/cardano/"]
                      [ P.text $ translate (I18nL.footer <<< I18nL.fooIohkSupportP) lang' ]
                  , P.div
                      [ P.className "logo__container"]
                      [ P.a
                          [ P.className "logo_iohk_name__img bg-iohk-logo"
                          , P.href "https://iohk.io/"]
                          []
                      ]
                  ]
              ,  P.div
                  [ P.className "content content__right"]
                  [ langView state ]
              ]
          ]
    ]

-- nav

type NavItem =
    { label :: String
    , link :: String
    }

type NaviItemHeader = String

type NavRow =
    { header :: String
    , items :: Array NavItem
    }

resourcesNavRow :: Language -> NavRow
resourcesNavRow lang =
    { header: translate (I18nL.footer <<< I18nL.fooRessources) lang
    , items: navItemsRow0 lang }


navItemsRow0 :: Language -> Array NavItem
navItemsRow0 lang =
    [ { label: translate (I18nL.common <<< I18nL.cApi) lang
      , link: "https://github.com/input-output-hk/cardano-sl-explorer/blob/master/docs/cardano-explorer-table-web-api.md"
      }
    , { label: translate (I18nL.common <<< I18nL.cDocumentation) lang
      , link: "https://github.com/input-output-hk/cardano-sl-explorer/blob/master/docs/cardano-explorer-web-api.md"
      }
    -- TODO (ks) Add when we have the links
    -- , { label: "Support"
    --   , link: "/"
    --   }
    -- , { label: "Status"
    --   , link: "/"
    --   }
    -- , { label: "Charts"
    --   , link: "/"
    --   }
    ]

followUsNavRow :: Language -> NavRow
followUsNavRow lang =
    { header: translate (I18nL.footer <<< I18nL.fooFollow) lang
    , items: navItemsRow1 lang
    }

navItemsRow1 :: Language -> Array NavItem
navItemsRow1 lang =
    [ { label: translate (I18nL.common <<< I18nL.cGithub) lang
      , link: "https://github.com/input-output-hk/"
      }
    , { label: translate (I18nL.common <<< I18nL.cLinkedin) lang
      , link: "https://www.linkedin.com/company-beta/6385405/?pathWildcard=6385405"
      }
    , { label: translate (I18nL.common <<< I18nL.cTwitter) lang
      , link: "https://twitter.com/InputOutputHK"
      }
    ]

linksNavRow :: Language -> NavRow
linksNavRow  lang =
    { header: translate (I18nL.footer <<< I18nL.fooLinks) lang
    , items: navItemsRow2 lang
    }

navItemsRow2 :: Language -> Array NavItem
navItemsRow2 lang =
    [ { label: translate (I18nL.common <<< I18nL.cDaedalusWallet) lang
      , link: "https://daedaluswallet.io/"
      }
    , { label: translate (I18nL.common <<< I18nL.cWhyCardano) lang
      , link: "https://whycardano.com/"
      }
    , { label: translate (I18nL.common <<< I18nL.cCardanoRoadmap) lang
      , link: "https://cardanoroadmap.com/"
      }
    , { label: translate (I18nL.common <<< I18nL.cCardanoADAFaucet) lang
      , link: "https://tada.iohk.io/"
      }
    , { label: translate (I18nL.common <<< I18nL.cCardanoSLDocumentation) lang
      , link: "https://cardano-docs.iohk.io/introduction/"
      }
    ]

navRowView :: NavRow -> P.Html Action
navRowView row =
    P.div
        [ P.className "nav-item__container"]
        [ P.p
            [ P.className "nav-item__header"]
            [ P.text row.header ]
          , P.div
            []
            $ map navRowItemView row.items
        ]

navRowItemView :: NavItem -> P.Html Action
navRowItemView item =
    P.a
      [ P.className "nav-item__item", P.href item.link]
      [ P.text item.label ]

-- currency

langItems :: Array Language
langItems =
    [ English
    , German
    ]

langView :: State -> P.Html Action
langView state =
  P.select
      [ P.className "lang__select bg-arrow-up"
      , P.onChange $ SetLanguage <<< fromMaybe initialState.lang <<< readLanguage <<< _.value <<< _.target]
      $ map (langItemView state) langItems

langItemView :: State -> Language -> P.Html Action
langItemView state lang =
  P.option
    [ P.value $ show lang
    , P.selected $ state.lang == lang  ]
    [ P.text $ show lang ]
