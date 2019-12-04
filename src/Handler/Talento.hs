{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Talento where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

formTalento :: Form Talento
formTalento = renderBootstrap $ Talento 
    <$> areq textField "Nome: " Nothing
    <*> areq textField "Pré-requisito: " Nothing
    <*> areq textField "Descrição: " Nothing

getTalentoR :: Handler Html
getTalentoR = do
    (widget,enctype) <- generateFormPost formTalento
    
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/main.lucius")
        toWidgetHead $(luciusFile "templates/talento.lucius")
        $(whamletFile "templates/talento.hamlet")
        
postTalentoR :: Handler Html
postTalentoR = do
    ((result,_),_) <- runFormPost formTalento
    case result of 
        FormSuccess talento -> do
            runDB $ insert talento
            redirect ListTalentoR
        _ -> redirect HomeR
        
getListTalentoR :: Handler Html 
getListTalentoR = do 
    talentos <- runDB $ selectList [] [Asc TalentoNome]
    defaultLayout $ do 
        $(whamletFile "templates/talentos.hamlet")