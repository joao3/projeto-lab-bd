import psycopg2
import logging

class Db:
    def __init__(self, dbname, user):
        self.dbname = dbname
        self.user = user
        self.connection = None
        self.cursor = None
        self.logger = self.setup_logger()

    def conectar(self):
        try:
            self.connection = psycopg2.connect(dbname=self.dbname, user=self.user)
            self.cursor = self.connection.cursor()
            self.logger.info("Conectado na base")
        except (Exception, psycopg2.DatabaseError) as error:
            self.logger.error(f"Erro ao conectar na base: {error}")

    def desconectar(self):
        if self.connection:
            self.cursor.close()
            self.connection.close()
            self.logger.info("Desconectado da base")

    def query(self, query, vars=None):
        try:
            self.cursor.execute(query, vars)
            self.logger.info("Query executada")
            return self.cursor.fetchall()
        except (Exception, psycopg2.DatabaseError) as error:
            self.logger.error(f"Erro ao executar query: {error}")

    def commit(self):
        self.connection.commit()

    def setup_logger(self):
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