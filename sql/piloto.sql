-- =================================== Overview ===================================
-- Nome inteiro do piloto.
DROP FUNCTION IF EXISTS NomePiloto;
CREATE OR REPLACE FUNCTION NomePiloto(
    p_driverid INTEGER
) RETURNS TEXT AS $$
DECLARE
	v_fullname TEXT;
BEGIN
	SELECT forename || ' ' || surname FROM driver WHERE driverid = p_driverid INTO v_fullname;

    RETURN v_fullname;
END;
$$ LANGUAGE plpgsql;

-- Quantidade de vitórias do piloto.
DROP FUNCTION IF EXISTS VitoriasPiloto;
CREATE OR REPLACE FUNCTION VitoriasPiloto(
    p_driverid INTEGER
) RETURNS TEXT AS $$
DECLARE
	v_vitorias INTEGER;
BEGIN
	SELECT COUNT(*) FROM results WHERE driverid = p_driverid AND position = 1 INTO v_vitorias;

    RETURN v_vitorias;
END;
$$ LANGUAGE plpgsql;

-- Primeiro e último ano em que há registros do piloto.
DROP FUNCTION IF EXISTS AnosRegistroPiloto;
CREATE OR REPLACE FUNCTION AnosRegistroPiloto(
    p_driverid INTEGER
) RETURNS TABLE(first_year INTEGER, last_year INTEGER) AS $$
BEGIN
	RETURN QUERY 
		SELECT MIN(year), MAX(year) 
		FROM results JOIN races on races.raceid = results.raceid WHERE driverid = p_driverid;
END;
$$ LANGUAGE plpgsql;

-- =================================== Relatórios ===================================
-- Relatório Vitorias
DROP INDEX IF EXISTS idx_driver_results;
CREATE INDEX idx_driver_results ON results (driverid, position);

DROP FUNCTION IF EXISTS VitoriasPilotoRelatorio;
CREATE OR REPLACE FUNCTION VitoriasPilotoRelatorio(
    p_driverid INTEGER
) RETURNS TABLE(race_year INTEGER, race_name TEXT, quantidade BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT year, name, count(*) AS quantidade
			FROM results
			JOIN races ON races.raceid = results.raceid
			WHERE driverid = p_driverid AND position = 1
			GROUP BY ROLLUP (year, name) ORDER BY year, name;
END;
$$ LANGUAGE plpgsql;

-- Relatório - Resultados
DROP FUNCTION IF EXISTS ResultadosPiloto;
CREATE OR REPLACE FUNCTION ResultadosPiloto(
    p_driverid INTEGER
) RETURNS TABLE(status TEXT, quantidade BIGINT) AS $$
BEGIN
    RETURN QUERY
		SELECT s.status, count(*) FROM results r JOIN status s ON r.statusid = s.statusid  
		WHERE driverid = p_driverid 
		GROUP BY s.status ORDER BY COUNT(*) DESC;
END;
$$ LANGUAGE plpgsql;