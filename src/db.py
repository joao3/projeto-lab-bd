import psycopg2
import logging

class Db:
    def __init__(self, dbname, user):
        # Atributos de conexão com o banco.
        self.dbname = dbname
        self.user = user
        self.connection = None
        self.cursor = None
        self.logger = self.setup_logger()

    def conectar(self):
        # Tenta conectar com a base.
        try:
            self.connection = psycopg2.connect(dbname=self.dbname, user=self.user, )
            self.cursor = self.connection.cursor()
            self.logger.info("Conectado na base")
        except (Exception, psycopg2.DatabaseError) as error:
            self.logger.error(f"Erro ao conectar na base: {error}")

    def desconectar(self):
        # Desconecta da base.
        if self.connection:
            self.cursor.close()
            self.connection.close()
            self.logger.info("Desconectado da base")

    def query(self, query, vars=None):
        # Faz uma query e retorna o resultado.
        try:
            self.cursor.execute(query, vars) # Lib inicia a transação aqui.
            self.logger.info("Query executada")
            return self.cursor.fetchall()
        except (Exception, psycopg2.DatabaseError) as error:
            self.logger.error(f"Erro ao executar query: {error}")

    def commit(self):
        self.connection.commit()

    def setup_logger(self):
        # Inicia o logger (debug).
        logger = logging.getLogger("PostgreSQLConnection")
        logger.setLevel(logging.INFO)
        file_handler = logging.FileHandler("../logs/database.log")
        formatter = logging.Formatter(
            "%(asctime)s - %(levelname)s - %(message)s",
            "%Y-%m-%d %H:%M:%S"
        )
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
        return logger
