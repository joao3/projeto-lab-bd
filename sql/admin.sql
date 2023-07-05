-- =================================== Overview ===================================

-- Quantidade de pilotos
DROP FUNCTION IF EXISTS QuantidadePilotosAdmin;
CREATE OR REPLACE FUNCTION QuantidadePilotosAdmin() 
RETURNS TABLE(contagem BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT COUNT(*) FROM driver;
END;
$$ LANGUAGE plpgsql;

-- Quantidade de escuderias
DROP FUNCTION IF EXISTS QuantidadeEscuderiasAdmin;
CREATE OR REPLACE FUNCTION QuantidadeEscuderiasAdmin() 
RETURNS TABLE(contagem BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT COUNT(*) FROM constructors;
END;
$$ LANGUAGE plpgsql;

-- Quantidade de corridas
DROP FUNCTION IF EXISTS QuantidadeCorridasAdmin;
CREATE OR REPLACE FUNCTION QuantidadeCorridasAdmin() 
RETURNS TABLE(contagem BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT COUNT(*) FROM races;
END;
$$ LANGUAGE plpgsql;

-- Quantidade de temporadas
DROP FUNCTION IF EXISTS QuantidadeTemporadasAdmin;
CREATE OR REPLACE FUNCTION QuantidadeTemporadasAdmin() 
RETURNS TABLE(contagem BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT COUNT(*) FROM seasons;
END;
$$ LANGUAGE plpgsql;

-- =================================== Ações ===================================

-- Cadastrar escuderia
DROP FUNCTION IF EXISTS CadastrarEscuderia;
CREATE OR REPLACE FUNCTION CadastrarEscuderia(
  p_constructorref TEXT,
	p_name TEXT,
	p_nationality TEXT,
	p_url TEXT
) RETURNS TABLE(a TEXT) AS $$
DECLARE
	id INTEGER;
BEGIN
	SELECT MAX(constructorid) + 1 FROM constructors INTO id;
	
    INSERT INTO constructors
	VALUES (id, p_constructorref, p_name, p_nationality, p_url);
END;
$$ LANGUAGE plpgsql;

-- Cadastrar piloto
DROP FUNCTION IF EXISTS CadastrarPiloto;
CREATE OR REPLACE FUNCTION CadastrarPiloto(
  	p_driverref TEXT,
	p_number INTEGER,
	p_code TEXT,
	p_forename TEXT,
	p_surname TEXT,
	p_dob DATE,
	p_nationality TEXT
) RETURNS TABLE(a TEXT) AS $$
DECLARE
	id INTEGER;
BEGIN
	SELECT MAX(driverid) + 1 FROM driver INTO id;
	
    INSERT INTO driver
	VALUES (id, p_driverref, p_number, p_code, p_forename, p_surname, p_dob, p_nationality, NULL);
END;
$$ LANGUAGE plpgsql;