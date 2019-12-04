{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Arma where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

formArma :: Form Arma 
formArma = renderBootstrap $ Arma 
    <$> areq textField "Nome: " Nothing
    <*> areq doubleField "Preço: " Nothing
    <*> areq doubleField "Peso: " Nothing
    <*> areq textField "Dano: " Nothing
    <*> areq textField "Propriedades: " Nothing

getArmaR :: Handler Html
getArmaR = do
    (widget,enctype) <- generateFormPost formArma
    
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/main.lucius")
        toWidgetHead $(luciusFile "templates/arma.lucius")
        $(whamletFile "templates/arma.hamlet")
        
postArmaR :: Handler Html
postArmaR = do
    ((result,_),_) <- runFormPost formArma
    case result of 
        FormSuccess arma -> do
            runDB $ insert arma
            redirect ArmaR
        _ -> redirect HomeR 