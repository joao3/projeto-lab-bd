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

-- =================================== Relatórios ===================================

-- Relatório 1: Resultados
DROP FUNCTION IF EXISTS ResultadosAdmin;
CREATE OR REPLACE FUNCTION ResultadosAdmin() 
RETURNS TABLE(status TEXT, quantidade BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT s.status, count(*) 
		FROM results r JOIN status s ON r.statusid = s.statusid 
		GROUP BY s.status ORDER BY COUNT(*) DESC;
END;
$$ LANGUAGE plpgsql;

-- Relatório 2: Aeroportos
CREATE EXTENSION IF NOT EXISTS cube;
CREATE EXTENSION IF NOT EXISTS earthdistance;

DROP INDEX IF EXISTS idx_admin_airports;
CREATE INDEX idx_admin_airports ON geocities15k (name);

DROP FUNCTION IF EXISTS AeroportosCidade;
CREATE OR REPLACE FUNCTION AeroportosCidade(p_cidade TEXT) 
RETURNS TABLE(c_name TEXT, country CHARACTER, iata CHARACTER, a_name TEXT, city TEXT, a_country CHARACTER, distance DOUBLE PRECISION, type CHARACTER) AS $$
BEGIN
    RETURN QUERY
		SELECT c.name, c.country, a.iatacode, a.name, a.city, a.isocountry,
       	earth_distance(ll_to_earth(c.lat, c.long), ll_to_earth(a.latdeg, a.longdeg)) AS distance,
       	a.type
		FROM geocities15k c
		JOIN airports a ON c.name = p_cidade
		WHERE a.type IN ('medium_airport', 'large_airport')
  		AND earth_distance(ll_to_earth(c.lat, c.long), ll_to_earth(a.latdeg, a.longdeg)) <= 100000 -- 100 km em metros = 100000
		ORDER BY c.country, earth_distance(ll_to_earth(c.lat, c.long), ll_to_earth(a.latdeg, a.longdeg));
END;
$$ LANGUAGE plpgsql;