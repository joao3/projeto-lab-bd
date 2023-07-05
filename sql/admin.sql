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