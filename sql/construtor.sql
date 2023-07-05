-- =================================== Overview ===================================

-- Nome
DROP FUNCTION IF EXISTS NomeEscuderia;
CREATE OR REPLACE FUNCTION NomeEscuderia(
    p_constructorid INTEGER
) RETURNS TABLE(nome TEXT) AS $$
BEGIN
	RETURN QUERY
		SELECT name FROM constructors WHERE constructorid = p_constructorid;
END;
$$ LANGUAGE plpgsql;

-- Quantidade de vitórias
DROP FUNCTION IF EXISTS VitoriasEscuderia;
CREATE OR REPLACE FUNCTION VitoriasEscuderia(
    p_constructorid INTEGER
) RETURNS TABLE(vitorias BIGINT) AS $$
BEGIN
	RETURN QUERY
		SELECT COUNT(*) FROM results WHERE constructorid = p_constructorid AND position = 1;
END;
$$ LANGUAGE plpgsql;

-- Quantidade de pilotos
DROP FUNCTION IF EXISTS QuantidadePilotosEscuderia;
CREATE OR REPLACE FUNCTION QuantidadePilotosEscuderia(
    p_constructorid INTEGER
) RETURNS TABLE(vitorias BIGINT) AS $$
BEGIN
	RETURN QUERY
		SELECT COUNT(DISTINCT driverid) FROM results WHERE constructorid = p_constructorid;
END;
$$ LANGUAGE plpgsql;

-- Primeiro e último ano em que há registros da escuderia.
DROP FUNCTION IF EXISTS AnosRegistroEscuderia;
CREATE OR REPLACE FUNCTION AnosRegistroEscuderia(
    p_constructorid INTEGER
) RETURNS TABLE(first_year INTEGER, last_year INTEGER) AS $$
BEGIN
	RETURN QUERY 
		SELECT MIN(year), MAX(year) 
		FROM results JOIN races on races.raceid = results.raceid WHERE constructorid = p_constructorid;
END;
$$ LANGUAGE plpgsql;


-- =================================== Ações ===================================

-- Consultar por forename
DROP FUNCTION IF EXISTS ConsultarForename;
CREATE OR REPLACE FUNCTION ConsultarForename(
    p_constructorid INTEGER,
	p_forename TEXT
) RETURNS TABLE(nome TEXT, dob DATE, nationality TEXT) AS $$
BEGIN
    RETURN QUERY
		SELECT DISTINCT forename || ' ' || surname, d.dob, d.nationality 
		FROM results r JOIN driver d ON r.driverid = d.driverid 
		WHERE constructorid = p_constructorid AND forename = p_forename;
END;
$$ LANGUAGE plpgsql;

-- =================================== Relatórios ===================================
-- Relatório 3: Pilotos
DROP INDEX IF EXISTS idx_constructor_drivers;
CREATE INDEX idx_constructor_drivers ON results (driverid, constructorid, position);

DROP FUNCTION IF EXISTS PilotosEscuderia;
CREATE OR REPLACE FUNCTION PilotosEscuderia(
    p_constructorid INTEGER
) RETURNS TABLE(nome TEXT, quantidade BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT forename || ' ' || surname, COUNT(*)
		FROM results r JOIN driver d ON r.driverid = d.driverid
		WHERE constructorid = p_constructorid AND position = 1 
		GROUP BY forename || ' ' || surname ORDER BY COUNT(*) DESC;
END;
$$ LANGUAGE plpgsql;

-- Relatório 4: Resultados
DROP FUNCTION IF EXISTS ResultadosEscuderia;
CREATE OR REPLACE FUNCTION ResultadosEscuderia(
    p_constructorid INTEGER
) RETURNS TABLE(status TEXT, quantidade BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT s.status, count(*) FROM results r JOIN status s ON r.statusid = s.statusid  
		WHERE constructorid = p_constructorid 
		GROUP BY s.status ORDER BY COUNT(*) DESC;
END;
$$ LANGUAGE plpgsql;