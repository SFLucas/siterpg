{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
    
        toWidgetHead [julius|
            function ola(){
                alert("CONTRUCAO");
            }
        |]
        toWidgetHead [lucius|
            h1 {
                color: red;
            }
        |]
        [whamlet|
            <h1>
                SITE EM CONSTRUCAO!
                
            <img src=@{StaticR rpg_jpg}>
                
            <button class="btn btn-danger" onclick="ola()">
                OK
        |]
