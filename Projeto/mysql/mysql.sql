
/*create schema site;*/



/*
** DROP tables
*/


DROP SCHEMA RPG;



/*
**CREATE TABLES
*/
CREATE SCHEMA RPG;

CREATE TABLE RPG.Users (
  UserID INT AUTO_INCREMENT,
  username varchar(30),
  password varchar(30),
  PRIMARY KEY (`UserID`)
);

CREATE TABLE RPG.Poder(
  PoderID INT auto_increment,
  Descricao VARCHAR(100),
  NivelPoder INT(3),
  PRIMARY KEY `PK_PoderID` (`PoderID`)
);

CREATE TABLE RPG.Classe(
	ClasseID INT AUTO_INCREMENT,
	Nome VARCHAR(30),
    Descricao VARCHAR(150),
    
	PRIMARY KEY `PK_ClasseID` (`ClasseID`)
);
CREATE TABLE RPG.Raca(
	RacaID INT AUTO_INCREMENT,
	Nome VARCHAR(30),
    Descricao VARCHAR(150),
    
	PRIMARY KEY `PK_RacaID` (`RacaID`)
);
CREATE TABLE RPG.Heroi(
  HeroiID INT AUTO_INCREMENT,
  UserID INT,
  Nome VARCHAR(50),
  Codinome VARCHAR(50),
  Idade INT(2),
  Planeta VARCHAR(50),
  RacaID INT,
  ClasseID INT,
  PoderID INT,
  PRIMARY KEY `PK_HeroiID` (`HeroiID`),
  CONSTRAINT `FK_RacaID` FOREIGN KEY (`RacaID`) REFERENCES `Raca` (`RacaID`),
  CONSTRAINT `FK_PoderID` FOREIGN KEY (`PoderID`) REFERENCES `Poder` (`PoderID`),
  CONSTRAINT `FK_ClasseID` FOREIGN KEY (`ClasseID`) REFERENCES `Classe` (`ClasseID`),
  CONSTRAINT `FK_UserID` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`)
);
CREATE TABLE RPG.Estatus (
  HeroiID INT,
  Forca INT,
  Constituicao INT,
  Destreza INT,
  Agilidade INT,
  Inteligencia INT,
  ForcaVontade INT,
  Percepcao INT,
  Carisma INT,
  CONSTRAINT `FK_HeroiID` FOREIGN KEY (`HeroiID`) REFERENCES `Heroi` (`HeroiID`)
);
CREATE TABLE RPG.TipoMagia(
	TipoMagiaID INT AUTO_INCREMENT,
    Nome VARCHAR(50),
    
  PRIMARY KEY `PK_TipoMagiaID` (`TipoMagiaID`)
);

CREATE TABLE RPG.Magias (
  MagiaID INT AUTO_INCREMENT,
  Nome VARCHAR(40),
  NivelEncantamento INT,
  TipoMagiaID INT,
  TempoConjuracao VARCHAR(30),
  Alcance VARCHAR(30),
  Componente VARCHAR(30),
  Duracao VARCHAR(150),
  PRIMARY KEY `PK_MagiaID` (`MagiaID`),
  CONSTRAINT `FK_TipoMagiaID` FOREIGN KEY (`TipoMagiaID`) REFERENCES `TipoMagia` (`TipoMagiaID`)
);
INSERT INTO RPG.Raca(Nome, Descricao)
VALUES  ('Aarakocra',''),
		('Aasimar Caído',''),
		('Aasimar Flagelo',''),
		('Aasimar Protetor',''),
		('Alto Elfo',''),
		('Anão Da Colina',''),
		('Anão Da Montanha',''),
		('Bugbear',''),
		('Elfo Da Floresta',''),
		('Elfo Negro (Drow)',''),
		('Firbolg',''),
		('Genasi Da Terra',''),
		('Genasi De Água',''),
		('Genasi Do Ar',''),
		('Genasi Do Fogo',''),
		('Gnomo Da Floresta',''),
		('Gnomo Das Profundesas',''),
		('Gnomo Das Rochas',''),
		('Goblin',''),
		('Golias',''),
		('Halfling Pés Leves',''),
		('Halfling Robusto',''),
		('Hobgoblin',''),
		('Homem-Lagarto',''),
		('Humano',''),
		('Kenku',''),
		('Kobold',''),
		('Meio-Elfo',''),
		('Meio-Orc',''),
		('Orc',''),
		('Tabaxi',''),
		('Tiefling',''),
		('Tritão',''),
		('Yuan-Ti Sangue-Puro','');

INSERT INTO RPG.Classe(Nome, Descricao)
VALUES  ('Bardo','Canta'),
		('Bruxo','Magia Negra'),
		('Clerigo','Cura'),
		('Druida','Se transforma'),
		('Feiticeiro','que?'),
		('Guerreiro','tanka?'),
		('Ladino','rouba'),
		('Mago','Solta magia'),
		('Paladino','rouba'),
		('Patrulheiro','patrulha?');
       
INSERT INTO RPG.TipoMagia(Nome)
VALUES  ('Abjuração'),
		('Advinhação'),
		('Conjuração'),
		('Encantamento'),
		('Evocação'),
		('Ilusão'),
		('Necromancia'),
		('Transmutação');
INSERT INTO RPG.Magias(Nome, NivelEncantamento,TipoMagiaID,TempoConjuracao,Alcance,Componente,Duracao)
VALUES  ('Acalmar Emoções (Calm Emotions)','2','4','1 ação','60 pés','V S','Fontes: Livro do Jogador pg 221'),
		('Amizade (Friends)','0','4','1 ação','pessoal','S M','Fontes: Livro do Jogador pg 244');
INSERT INTO RPG.users(username, password)
VALUES  ('1','1'),
		('2','2'),
		('3','3'),
		('asd','asd');

INSERT INTO RPG.Poder(Descricao,NivelPoder)
VALUES	('Fire',1),
		('Earth',1),
		('Air',1),
		('Ice',1);

INSERT INTO RPG.Heroi(UserID,Nome,Codinome,Idade,Planeta,RacaID, ClasseID,PoderID)
VALUES	(1,'Firaga','fira',1000,'Terra',1,1,1),
		(2,'Earthquake','quake',1000,'Terra',3,3,2),
        (3,'Earoga','aera',1000,'Terra',4,4,3),
		(4,'Blizzaga','Blizzara',20,'Idade Media',7,5,4);

INSERT INTO RPG.Estatus(HeroiID, Forca,Constituicao,Destreza,AgilIDade,Inteligencia,ForcaVontade,Percepcao,Carisma)
VALUES  (1,1,2,3,4,5,6,7,8),
		(2,1,1,1,1,1,1,1,1),
		(3,2,0,7,30,4,2,10,1),
		(4,0,0,0,0,1,1,1,1);

CREATE PROCEDURE RPG.SelectStatus(ID INT)
	SELECT 	estatus.Forca, 
			estatus.Constituicao, 
            estatus.Destreza, 
            estatus.AgiliDade, 
            estatus.Inteligencia, 
            estatus.ForcaVontade, 
            estatus.Percepcao, 
            estatus.Carisma 
	FROM RPG.Heroi
    INNER JOIN RPG.Estatus ON Heroi.HeroiID = estatus.HeroiID 
	WHERE Heroi.HeroiID=ID;

CREATE PROCEDURE RPG.InsertUser(nome VARCHAR(30), senha VARCHAR(30))
	INSERT INTO users(username, password) VALUES(nome, senha);

/*
**PROCEDURES Inserts
*/
CREATE PROCEDURE RPG.InsertPoder(
  NewDescricao VARCHAR(100),
  NewNivelPoder INT(3)
  )
  INSERT INTO RPG.Poder (Descricao, NivelPoder)
    VALUES (NewDescricao,NewNivelPoder)
;

CREATE PROCEDURE RPG.InsertHeroi(
  newUserID INT,
  NewNome VARCHAR(50),
  NewCodinome VARCHAR(50),
  NewIdade INT,
  NewPlaneta VARCHAR(50),
  NewRacaID INT,
  NewClasseID INT,
  NewPoderID INT
  )
  INSERT INTO RPG.Heroi (UserID, Nome, Codinome, Idade, Planeta, RacaID, ClasseID, PoderID)
    VALUES (newUserID,NewNome,NewCodinome,NewIDade,NewPlaneta,NewRacaID,NewClasseID,NewPoderID)
;

/*
**PROCEDURES Delete
*/

CREATE PROCEDURE RPG.deletePoder(
  DeletePoderID INT
  )
    DELETE FROM RPG.Poder
    WHERE Poder.PoderID = DeletePoderID
;
CREATE PROCEDURE RPG.deleteHeroi(
  DeleteHeroiID INT
  )
    DELETE FROM RPG.Heroi
    WHERE Heroi.HeroiID = DeleteHeroiID
;
/*
**PROCEDURES Update
*/

CREATE PROCEDURE RPG.UpdatePoder(
  UpdatePoderID INT,
  UpdateDescricao VARCHAR(100),
  UpdateNivelPoder INT(3)
  )
    UPDATE RPG.Poder
    SET 
		Poder.Descricao = UpdateDescricao, 
        Poder.NivelPoder = UpdateNivelPoder
    WHERE Poder.PoderID = UpdatePoderID
;
CREATE PROCEDURE RPG.UpdateHeroi(
  UpdateHeroiID INT,
  UpdateNome VARCHAR(50),
  UpdateCodinome VARCHAR(50),
  UpdateIdade INT,
  UpdatePlaneta VARCHAR(50),
  UpdatePoderID INT
  )
    UPDATE RPG.Heroi
    SET
        Heroi.Nome = UpdateNome,
    Heroi.Codinome = UpdateCodinome,
    Heroi.Idade = UpdateIdade,
    Heroi.Planeta = UpdatePlaneta,
    Heroi.PoderID = UpdatePoderID
    WHERE Heroi.HeroiID = UpdateHeroiID
;

/*
**PROCEDURES SELECT
*/

CREATE PROCEDURE RPG.SelectPoder(
  SelectPoderID INT
)
    SELECT 
    Poder.Descricao, 
    Poder.NivelPoder 
  FROM Poder
    
    WHERE Poder.PoderID = SelectPoderID
;
CREATE PROCEDURE RPG.SelectHeroi(
  SelectHeroiID INT
  )
    SELECT
		Users.Username,
		Heroi.Nome,
		Heroi.Codinome,
		Heroi.IDade,
		Heroi.Planeta,
		Poder.Descricao,
		Poder.NivelPoder,
		Raca.Nome,
		Classe.Nome,
		estatus.Forca, 
		estatus.Constituicao, 
		estatus.Destreza, 
		estatus.AgiliDade, 
		estatus.Inteligencia, 
		estatus.ForcaVontade, 
		estatus.Percepcao, 
		estatus.Carisma 
	FROM RPG.Heroi
	INNER JOIN RPG.Users ON Users.UserID = Heroi.UserID
	INNER JOIN RPG.Poder ON Poder.PoderID = Heroi.PoderID
	INNER JOIN RPG.Raca ON Raca.RacaID = Heroi.RacaID
	INNER JOIN RPG.Classe ON Classe.ClasseID = Heroi.ClasseID
	INNER JOIN RPG.Estatus ON Heroi.HeroiID = estatus.HeroiID 
	WHERE Heroi.HeroiID = SelectHeroiID
;


CREATE PROCEDURE RPG.SelectUserHeroi(
	username VARCHAR(30)
  )
    SELECT
    Users.Username,
    Heroi.HeroiID,
	Heroi.Nome
        
  FROM RPG.Heroi
    INNER JOIN RPG.Users ON Users.UserID = Heroi.UserID
    WHERE Users.Username = username
;


CALL RPG.InsertHeroi(1,'Brigandane','Jade',30,'terra',5,3,'3');
CALL RPG.InsertHeroi(1,'Fira','Mars',30,'Marte',5,3,'2');
CALL RPG.InsertHeroi(2,'Brigandane','Safira',30,'Lua',5,3,'3');
CALL RPG.InsertHeroi(1,'Fuego','Mar',30,'Mart',5,3,'4');

CALL RPG.SelectHeroi(4)
