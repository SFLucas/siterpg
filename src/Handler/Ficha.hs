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
    <*> areq intField "Nivel: " Nothing
    <*> areq intField "Vida: " Nothing
    <*> areq textField "Classe: " Nothing
    <*> areq textField "Raça: " Nothing
    <*> areq intField "Armadura: " Nothing
    <*> areq textField "Alinhamento: " Nothing
    <*> areq intField "Bônus de Proficiência: " Nothing
    <*> areq textField "Background: " Nothing
    <*> areq textField "Vínculos: " Nothing
    <*> areq textField "Ideais: " Nothing
    <*> areq textField "Defeitos: " Nothing
    <*> areq textField "Força: " Nothing
    <*> areq textField "Destreza: " Nothing
    <*> areq textField "Constituição: " Nothing
    <*> areq textField "Inteligência: " Nothing
    <*> areq textField "Sabedoria: " Nothing
    <*> areq textField "Carisma: " Nothing

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