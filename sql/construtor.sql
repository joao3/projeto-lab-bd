-- Overview

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