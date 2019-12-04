{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Ficha where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

formFicha :: Form Ficha
formFicha = renderBootstrap $ Ficha
    <$> areq textField "Nome: " Nothing
    <*> areq textField "Classe: " Nothing
    <*> areq textField "Raça: " Nothing
    <*> areq textField "Alinhamento: " Nothing
    <*> areq textField "Background: " Nothing
    <*> areq intField "Força: " Nothing
    <*> areq intField "Destreza: " Nothing
    <*> areq intField "Constituição: " Nothing
    <*> areq intField "Inteligência: " Nothing
    <*> areq intField "Sabedoria: " Nothing
    <*> areq intField "Carisma: " Nothing

getFichaR :: Handler Html
getFichaR = do
    (widget,enctype) <- generateFormPost formFicha
    
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/main.lucius")
        toWidgetHead $(luciusFile "templates/ficha.lucius")
        $(whamletFile "templates/ficha.hamlet")
        
postFichaR :: Handler Html
postFichaR = do
    ((result,_),_) <- runFormPost formFicha
    case result of 
        FormSuccess ficha -> do
            runDB $ insert ficha
            redirect FichaR
        _ -> redirect HomeR
        
getListFichaR :: Handler Html 
getListFichaR = do 
    fichas <- runDB $ selectList [] [Asc FichaNome]
    defaultLayout $ do 
        $(whamletFile "templates/fichas.hamlet")