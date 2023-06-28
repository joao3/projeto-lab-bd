-- Tabela de usuários.
DROP TABLE IF EXISTS Log_Table;
DROP TABLE IF EXISTS USERS;
CREATE TABLE USERS(
	userid UUID DEFAULT GEN_RANDOM_UUID() PRIMARY KEY,
	login VARCHAR(30) UNIQUE NOT NULL,
	password char(32) NOT NULL,
	type VARCHAR(13),
	originalid INTEGER DEFAULT NULL,

	CONSTRAINT CK_TYPE CHECK(TYPE IN ('Administrador', 'Escuderia', 'Piloto'))
);

-- Insere usuário admin.
INSERT INTO USERS (login, password, type) VALUES (
	'admin',
	MD5('admin'),
	'Administrador'
);

-- Insere escuderias já existentes.
INSERT INTO USERS (login, password, type, originalid)
	SELECT 
		constructorref || '_c', 
		MD5(constructorref), 
		'Escuderia', 
		constructorid 
	FROM constructors 
;

-- Insere pilotos já existentes.
INSERT INTO USERS (login, password, type, originalid)
	SELECT 
		driverref || '_d', 
		MD5(driverref), 
		'Piloto', 
		driverid 
	FROM driver 
;


-- Trigger inserção de novo piloto ou escuderia.
CREATE OR REPLACE FUNCTION InsertUser() RETURNS TRIGGER AS $$
	BEGIN
		IF TG_TABLE_NAME = 'driver' THEN
			INSERT INTO USERS (login, password, type, originalid) VALUES (
				NEW.driverref || '_d',
				MD5(NEW.driverref),
				'Piloto',
				NEW.driverid
			);
		ELSEIF TG_TABLE_NAME = 'constructors' THEN
			INSERT INTO USERS (login, password, type, originalid) VALUES (
				NEW.constructorref || '_c',
				MD5(NEW.constructorref),
				'Escuderia',
				NEW.constructorid
			);
		END IF;
        RETURN NEW;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_InsertDriverUser AFTER INSERT ON Driver
	FOR EACH ROW
	EXECUTE FUNCTION InsertUser();
	
CREATE OR REPLACE TRIGGER TR_InsertConstructorUser AFTER INSERT ON Constructors
	FOR EACH ROW
	EXECUTE FUNCTION InsertUser();

-- Trigger atualização piloto ou escuderia.
CREATE OR REPLACE FUNCTION UpdateUser() RETURNS TRIGGER AS $$
	BEGIN
		IF TG_TABLE_NAME = 'driver' THEN
			UPDATE users SET 
				login = NEW.driverref || '_d',
				password = MD5(NEW.driverref)
			WHERE login = OLD.driverref || '_d';
		ELSEIF TG_TABLE_NAME = 'constructors' THEN
			UPDATE users SET 
				login = NEW.constructorref || '_c',
				password = MD5(NEW.constructorref)
			WHERE login = OLD.constructorref || '_c';
		END IF;
        RETURN NEW;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_UpdateDriverUser AFTER UPDATE OF driverref ON Driver
	FOR EACH ROW
	EXECUTE FUNCTION UpdateUser();
	
CREATE OR REPLACE TRIGGER TR_UpdateConstructorUser AFTER UPDATE OF constructorref ON Constructors
	FOR EACH ROW
	EXECUTE FUNCTION UpdateUser();

DROP TABLE IF EXISTS Log_Table;
CREATE TABLE Log_Table (
    userid UUID REFERENCES USERS (userid),
    login_date DATE DEFAULT CURRENT_DATE,
    login_time TIME DEFAULT CURRENT_TIME
);

-- Função utilizada para tentar fazer o login, recebe o login e a senha, se as credenciais estão certas, retorna o userid, caso contrário, NULL.
CREATE OR REPLACE FUNCTION LoginUser(
    p_login VARCHAR(30),
    p_password CHAR(32)
) RETURNS VARCHAR(13) AS $$
DECLARE
    v_userid UUID;
BEGIN
    SELECT userid INTO v_userid
    FROM USERS
    WHERE login = p_login AND password = MD5(p_password);

    IF v_userid IS NOT NULL THEN
		INSERT INTO Log_Table(userid) VALUES(v_userid);
    END IF;

    RETURN v_userid;
END;
$$ LANGUAGE plpgsql;