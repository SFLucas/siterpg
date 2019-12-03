{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getArmaR :: Handler Html
getArmaR = do
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/main.lucius")
        toWidgetHead $(luciusFile "templates/arma.lucius")
        $(whamletFile "templates/arma.hamlet")