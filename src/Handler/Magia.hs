{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Magia where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

formMagia :: Form Magia 
formMagia = renderBootstrap $ Magia 
    <$> areq textField "Nome: " Nothing
    <*> areq intField "Nivel: " Nothing
    <*> areq textField "Tipo: " Nothing
    <*> areq textField "Custo: " Nothing
    <*> areq textField "Descrição: " Nothing
    <*> areq intField "Alcance: " Nothing

getMagiaR :: Handler Html
getMagiaR = do
    (widget,enctype) <- generateFormPost formMagia
    
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/main.lucius")
        toWidgetHead $(luciusFile "templates/magia.lucius")
        $(whamletFile "templates/magia.hamlet")
        
postMagiaR :: Handler Html
postMagiaR = do
    ((result,_),_) <- runFormPost formMagia
    case result of 
        FormSuccess magia -> do
            runDB $ insert magia
            redirect ListMagiaR
        _ -> redirect HomeR
        
getListMagiaR :: Handler Html 
getListMagiaR = do 
    magias <- runDB $ selectList [] [Asc MagiaNome]
    defaultLayout $ do 
        $(whamletFile "templates/magias.hamlet")