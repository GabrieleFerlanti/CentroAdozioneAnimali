CREATE DATABASE IF NOT EXISTS centroadozioneanimali; #Crea un database [CREATE DATABASE] se non esiste [IF NOT EXISTS] e gli assegna il [nomecentroadozioneanimali]  

USE centroadozioneanimali; #Seleziona il database su cui eseguire le operazioni

CREATE TABLE IF NOT EXISTS Persone ( #Crea la tabella se non esiste
    CodiceFiscale CHAR (16) NOT NULL, #Dichiara l'attributo di tipo [CHAR(16)] non permette stringhe di lunghezza maggiore o minore di 16 - [NOT NULL] il valore non può essere NULL
    Nome VARCHAR (20) NOT NULL, #Dichiara l'attributo [VARCHAR(20)] non permette stringhe di lunghezza superiore a 20
    Cognome VARCHAR (20) NOT NULL,
    Indirizzo VARCHAR (50) NULL,
    Numero VARCHAR (15) NULL UNIQUE, # [UNIQUE] non ci possono essere duplicati
    Email VARCHAR (50) NULL UNIQUE,
    PRIMARY KEY (CodiceFiscale) #Specifica che la chiave primaria della tabella è l'attributo [CodiceFisclale]
);

CREATE TABLE IF NOT EXISTS CategoriaAnimali (
    IdCategoriaAnimali INT (3) AUTO_INCREMENT, #[AUTO_INCREMENT] non bisogna inserire valori nella colonna perchè sarà inserito un valore crescente partendo da 1
    Tipologia VARCHAR (5) NOT NULL,
    Mantello VARCHAR (10), 
    Stazza VARCHAR (10),
    Razza VARCHAR (50) UNIQUE,
    PRIMARY KEY (IdCategoriaAnimali)
);

CREATE TABLE IF NOT EXISTS CartellaClinica (
    IdCartellaClinica INT(3) AUTO_INCREMENT,
    Stato VARCHAR (6) NULL, 
    Descrizione VARCHAR (500) NULL,
    PRIMARY KEY (IdCartellaClinica)
);

CREATE TABLE IF NOT EXISTS Animali (
    Microchip CHAR (15) NOT NULL,
    Nome VARCHAR (50),
    Eta INT (3),
    IdCategoriaAnimali INT (3),
    IdCartellaClinica INT(3),
    PRIMARY KEY (Microchip),
    FOREIGN KEY (IdCategoriaAnimali) REFERENCES CategoriaAnimali(IdCategoriaAnimali), #Specifica che [idCategoriaAnimali] è una chiave esterna [FOREIGN KEY] e si riferisce [REFERENCES] alla tabella [CategoriaAnimali] e all'attributo [IdCategoriaAnimali] 
    FOREIGN KEY (IdCartellaClinica) REFERENCES CartellaClinica(IdCartellaClinica)
);

CREATE TABLE IF NOT EXISTS Donazioni (
    IdDonazione INT (3) AUTO_INCREMENT,
    CodiceFiscale CHAR (16) NOT NULL,
    Importo DOUBLE (10, 2) NOT NULL , 
    Data DATE, 
    PRIMARY KEY (IdDonazione),
    FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale)
);


CREATE TABLE IF NOT EXISTS CategoriaDipendenti (
    IdCategoriaDipendenti INT (3) AUTO_INCREMENT, 
    Descrizione VARCHAR (20) NOT NULL,
    Stipendio DOUBLE (6,2) DEFAULT 0, 
    PRIMARY KEY (IdCategoriaDipendenti)
);

CREATE TABLE IF NOT EXISTS Appartengono (
    CodiceFiscale CHAR (16) NOT NULL,
    IdCategoriaDipendenti INT (3),
    FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale),
    FOREIGN KEY (IdCategoriaDipendenti) REFERENCES CategoriaDipendenti(IdCategoriaDipendenti),
    PRIMARY KEY (CodiceFiscale, IdCategoriaDipendenti) #Specifica che la chiave primaria è formata dalla coppia di attributi [CodiceFiscale e IdCategoriaDipendenti]
);

CREATE TABLE IF NOT EXISTS Adottano (
    CodiceFiscale CHAR (16) NOT NULL,
    Microchip CHAR (15) NOT NULL,
    Data DATE,
    FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale),
    FOREIGN KEY (Microchip) REFERENCES Animali(Microchip),
    PRIMARY KEY (Microchip, CodiceFiscale) 
);

CREATE TABLE IF NOT EXISTS Registrano ( 
    CodiceFiscale CHAR (16) NOT NULL, 
    Microchip CHAR (15) NOT NULL, 
    Data DATE,
    FOREIGN KEY (CodiceFiscale) REFERENCES Persone(CodiceFiscale),
    FOREIGN KEY (Microchip) REFERENCES Animali(Microchip),
    PRIMARY KEY (Microchip, CodiceFiscale)
);

INSERT INTO Persone #Inserisce [INSERT INTO] nella tabella [Persone]
    (CodiceFiscale, Nome, Cognome, Indirizzo, Numero, Email) #Specifica gli attributi a cui bisogna assegnare i valori
VALUES #Valori da aggiungere
    ('RSSMRA97M15A001G', 'Alessandro', 'Rossi', 'Via Roma 10', '3471234567', 'alessandro.rossi@example.com'), # ('CodiceFiscale', 'Nome', 'Cognome', 'Indirizzo', 'Numero', 'Email')
    ('LNNPLA91M45B002Y', 'Martina', 'Bianchi', 'Via Garibaldi 25', '5559876543', 'martina.bianchi@example.com'),
    ('GRTPLM84C30C003Z', 'Luca', 'Esposito', 'Corso Vittorio Emanuele 15', '6892345678', 'luca.esposito@example.com'),
    ('FSCGNI93P12D004X', 'Sofia', 'Russo', 'Piazza San Marco 7', '1234567890', 'sofia.russo@example.com');

INSERT INTO CategoriaDipendenti 
    (IdCategoriaDipendenti, Descrizione, Stipendio)
VALUES 
    (1, 'volontario', NULL),
    (2, 'Livello 1', 2500.00),
    (3, 'Livello 2', 1500.00);

INSERT INTO Appartengono 
    (CodiceFiscale, IdCategoriaDipendenti)
VALUES 
    ('RSSMRA97M15A001G', 1),
    ('LNNPLA91M45B002Y', 2),
    ('GRTPLM84C30C003Z', 3),
    ('FSCGNI93P12D004X', 2);



DELIMITER // #Cambia il delimitatore tra le istruzioni
CREATE DEFINER = root@localhost # Definisce chi usa la procedura, prende in input dei dati ma non ritorna niente
PROCEDURE RegistraPersona # Nome della procedura
    (IN _codicefiscale CHAR(16), IN _nome VARCHAR(20), IN _cognome VARCHAR(20), IN _indirizzo VARCHAR(50), IN _numero VARCHAR(15), IN _email VARCHAR(50)) #Valori in INPUT
BEGIN #Inizio
    INSERT INTO Persone (CodiceFiscale, Nome, Cognome, Indirizzo, Numero, Email)
    VALUES (_codicefiscale, _nome, _cognome, _indirizzo, _numero, _email);
END // #Fine
DELIMITER ; #Ripristino del delimitatore

DELIMITER //
CREATE DEFINER = root@localhost
PROCEDURE RegistraAnimale
    (IN _codicefiscale CHAR(16), IN _microchip CHAR(15), IN _nome VARCHAR(50), IN _eta INT(3), IN _tipologia VARCHAR (5), IN _Mantello VARCHAR (10), IN _stazza VARCHAR (10), IN _razza VARCHAR(50), IN _data DATE)
BEGIN 
    DECLARE idCategoria INT (3); #Variabili locali [DECLARE] nomeVariabile [TIPO]
    DECLARE idCartella INT (3);
    IF NOT EXISTS (SELECT CodiceFiscale FROM Persone WHERE CodiceFiscale = _codicefiscale) #Controllo condizionale [IF] Condizione 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "UTENTE NON REGISTRATO"; #[THEN] Istruzioni se la condizione è vera
     ELSE #[ELSE] se la condizone è falsa
        IF NOT EXISTS (SELECT Razza FROM CategoriaAnimali WHERE Razza = _razza)
        THEN 
            INSERT INTO CategoriaAnimali (Tipologia, Mantello, Stazza, Razza) VALUES (_tipologia, _Mantello, _stazza, _razza);
        END IF;
            INSERT INTO CartellaClinica (IdCartellaClinica,Stato,Descrizione) VALUES (NULL,NULL,NULL);
            SET idCategoria = (SELECT IdCategoriaAnimali FROM CategoriaAnimali WHERE Razza = _razza); #Settare la variabile con un valore diverso
            SET idCartella = (SELECT MAX(IdCartellaClinica) FROM  CartellaClinica);
            INSERT INTO Animali (Microchip, Nome, Eta, IdCategoriaAnimali, IdCartellaClinica) VALUES (_microchip, _nome, _eta, idCategoria, idCartella);
            INSERT INTO Registrano (CodiceFiscale,  Microchip, Data) VALUES (_codicefiscale, _microchip, _data);
    END IF; #[END IF] fine del controllo
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER = root@localhost
PROCEDURE Donazione
    (IN _codicefiscale CHAR(16), IN _importo DOUBLE(10,2), IN _data DATE)
BEGIN
    IF NOT EXISTS (SELECT CodiceFiscale FROM Persone WHERE CodiceFiscale = _codicefiscale)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "UTENTE NON REGISTRATO"; #Segnala un errore personalizzato in questo caso un utente non registrato
    ELSE
        INSERT Donazioni (Codicefiscale, Importo, Data) VALUES (_codicefiscale, _importo, _data);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER = root@localhost
PROCEDURE AdottanoAnimale
    (IN _codicefiscale CHAR(16), IN _microchip CHAR(15), IN _data DATE)
BEGIN 
    IF NOT EXISTS (SELECT CodiceFiscale FROM Persone WHERE CodiceFiscale =  _codicefiscale)
    THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "UTENTE NON REGISTRATO";
    ELSE
        IF EXISTS (SELECT Microchip FROM Adottano WHERE Microchip = _microchip)
        THEN 
            SIGNAL SQLSTATE '46000' SET MESSAGE_TEXT = "ANIMALE GIÀ ADOTTATO";
        ELSE 
            INSERT INTO Adottano (CodiceFiscale, Microchip, Data) VALUES (_codicefiscale, _microchip, _data); 
        END IF;
    END IF;
END //
DELIMITER ;



DELIMITER // #FUNZIONI prendono valori in input e restituiscono in output 
CREATE DEFINER = root@localhost 
FUNCTION DonazioniRicevute #Nome della funzione [FUCTION] nomeFunzione
    (_periodo DATE)
RETURNS DOUBLE(10,2) #Tipo di ritorno [RETURNS]
BEGIN 
    DECLARE _sum DOUBLE(10,2);
    SET _sum = (SELECT SUM(Importo) FROM Donazioni WHERE Data >= _periodo);
    RETURN _sum; #Ritorno della variabile
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER = root@localhost
FUNCTION AnimaliAdottati 
    (_periodo DATE)
RETURNS INT
BEGIN 
    DECLARE _count INT;
    SET _count = (SELECT COUNT(*) FROM Adottano WHERE Data >= _periodo);
    RETURN _count;
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER = root@localhost
FUNCTION AnimaliRegistrati
    (_periodo DATE)
RETURNS INT
BEGIN 
    DECLARE _count INT;
    SET _count = (SELECT COUNT(*) FROM Registrano WHERE Data >= _periodo);
    RETURN _count;
END //
DELIMITER ;



#Registrare un animale con una persona già registrato 
CALL RegistraAnimale ('RSSMRA97M15A001G', '1A2B3C4D5E6F7G8', 'Luna', 1, 'cane', 'medio', 'grande', 'Golden Retriever', '2024-03-01'); #Chiamata [CALL] alla procedura RegistraAnimale ('ValoriDaPassare',)

#Registrare un animale con una persona non registrata
CALL RegistraAnimale ('BRSRPA88R25E005W', 'QW3E4R5T6Y7U8I9', 'Max', 3, 'cane', 'medio', 'grande', 'Pastore Tedesco', '2024-03-01');
CALL RegistraPersona ('BRSRPA88R25E005W', 'Giovanni', 'Ferrari', 'Via Dante Alighieri 30', '7775551234', 'giovanni.ferrari@example.com');
CALL RegistraAnimale ('BRSRPA88R25E005W', 'QW3E4R5T6Y7U8I9', 'Max', 3, 'cane', 'medio', 'grande', 'Pastore Tedesco', '2024-03-01');

CALL Donazione ('BRSRPA88R25E005W', '20.00', '2024-01-04');
CALL Donazione ('LNNPLA91M45B002Y', '900.00', '2024-02-01');
CALL Donazione ('BRSRPA88R25E005W', '700.00', '2024-02-04');


CALL AdottanoAnimale ('GRTPLM84C30C003Z', 'QW3E4R5T6Y7U8I9', '2024-04-01');
CALL AdottanoAnimale ('LNNPLA91M45B002Y', '1A2B3C4D5E6F7G8', '2024-03-03');

SELECT DonazioniRicevute ('2024-02-01'); #[SELECT] per invocare una funzione ('ValoriDaPassare',)

SELECT AnimaliAdottati ('2024-02-01');

SELECT AnimaliRegistrati('2024-02-01');