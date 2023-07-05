from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.table import Table

console = Console()

class Construtor:

    def __init__(self, db, userid):
        self.db = db
        self.userid = userid

        # Pega o id da escuderia.
        self.originalid = db.query("SELECT originalid FROM USERS WHERE userid = %s", (self.userid,))[0][0]
        self.db.commit()

        self.acoes()


    def overview(self):
        # Imprime o "header".
        console.clear()
        console.print(Panel(Text('Construtor', justify='center')))

        nome = self.db.query('SELECT * FROM NomeEscuderia(%s)', (self.originalid, ))[0][0]
        vitorias = self.db.query('SELECT * FROM VitoriasEscuderia(%s)', (self.originalid, ))[0][0]
        pilotos = self.db.query('SELECT * FROM QuantidadePilotosEscuderia(%s)', (self.originalid, ))[0][0]
        anos = self.db.query('SELECT * FROM AnosRegistroEscuderia(%s)', (self.originalid, ))[0]
        self.db.commit()
        
        text = f'Nome: {nome}\n'
        text += f'Quantidade de vitórias: {vitorias}\n'
        text += f'Quantidade de piltos (total): {pilotos}\n'
        text += f'Ano do primeiro registro: {anos[0]}\n'
        text += f'Ano do último registro: {anos[1]}'

        console.print(Panel(
            Text(text),
            title='Overview'
        ))

    def acoes(self):
        sair = False

        # Menu de ações.
        while not sair:
            self.overview()
            print('1 - Ir para relatórios')
            print('2 - Consultar por forename')
            print('0 - Sair')

            operacao = input('Insira a operação: ')

            if operacao == '1':
                self.relatorios()
            elif operacao == '2':
                self.consultar_forename()
            elif operacao == '0':
                sair = True
            else:
                input('Operação inválida, pressione enter para voltar... ')

    def consultar_forename(self):
        forename = input('Insira o forename que deseja consultar: ')

        # Pega os dados do banco.
        resultado = self.db.query('SELECT * FROM ConsultarForename(%s, %s)', (self.originalid, forename))
        self.db.commit()

        if resultado == []:
            input('Nenhum resultado encontrado, pressione enter para voltar...')
            return

        # Monta a tabela e imprime no console.
        table = Table(*['Nome', 'Data de nascimento', 'Nacionalidade'], title='Consulta por forename')
        for linha in resultado:
            table.add_row(linha[0].__str__(), linha[1].__str__(), linha[2].__str__())

        console.clear()
        console.print(table)
        input('Pressione enter para voltar... ')

    def relatorios(self):
        sair = False

        # Menu de relatórios.
        while not sair:
            console.clear()
            console.print(Panel(Text('Relatórios', justify='center')))
            print('1 - Lista de pilotos')
            print('2 - Quantidade de resultados')
            print('0 - Sair')

            operacao = input('Insira a operação: ')

            if operacao == '1':
                self.lista_pilotos()
            elif operacao == '2':
                self.quantidade_resultados()
            elif operacao == '0':
                sair = True
            else:
                input('Operação inválida, pressione enter para voltar... ')


    def lista_pilotos(self):
        input('Lista de pilotos... ') # pegar do banco

    def quantidade_resultados(self):
        input('Quantidade resultados... ')
