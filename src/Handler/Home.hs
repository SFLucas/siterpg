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

getPage1R :: Handler Html
getPage1R = do
    defaultLayout $ do
        toWidgetHead $(juliusFile "templates/page1.julius")
        toWidgetHead $(luciusFile "templates/page1.lucius")
        $(whamletFile "templates/page1.hamlet")

getPage2R :: Handler Html
getPage2R = do
    defaultLayout $ do
        $(whamletFile "templates/page2.hamlet")

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
            body {
                background-image: url(@{StaticR rpg_jpg});
                background-size: cover;
                background-repeat: no-repeat;
            }
            h1 {
                color: cyan;
            }
            ul {
                list-style: none;
            }
            li {
                display: inline;
            }
        |]
        [whamlet|
            <h1>
                SITE EM CONSTRUCAO!
                
            <ul>
                <li>
                    <a href=@{Page1R}
                        Pagina1
                <li>
                    <a href=@{Page2R}
                        Pagina2
                
            <button class="btn btn-danger" onclick="ola()">
                OK
        |]
