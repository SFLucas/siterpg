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

getArmaR :: Handler Html
getArmaR = do
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/main.lucius")
        toWidgetHead $(luciusFile "templates/arma.lucius")
        $(whamletFile "templates/arma.hamlet")
        
postArmaR :: Handler Html
postArmaR = do
    formArma <- runInputGet $ Arma
        <$> ireq textField "nome"
        <*> ireq doubleField "preco"
        <*> ireq doubleField "peso"
        <*> ireq textField "dano"
        <*> ireq textField "propriedades"
        
    ((result,_),_) <- runFormPost formArma
    case result of 
        FormSuccess arma -> do
            runDB $ insert arma
            setMessage [shamlet|
                <h2>
                    ARMA INSERIDA COM SUCESSO
            |]
            redirect ProdutoR
        _ -> redirect HomeR 