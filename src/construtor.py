from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.table import Table

console = Console()

class Construtor:

    def __init__(self, db, userid):
        self.db = db
        self.userid = userid
        self.originalid = db.query("SELECT originalid FROM USERS WHERE userid = %s", (self.userid,))[0][0]
        self.nome = self.db.query("SELECT name FROM constructors WHERE constructorid = %s;", (self.originalid,))[0][0]
        self.db.commit()

        self.acoes()


    def overview(self):
        console.clear()
        console.print(Panel(Text('Construtor', justify='center')))

        a = 'banco'

        text = f'Nome: {a}\n'
        text += f'Quantidade de vitórias: {a}\n'
        text += f'Quantidade de piltos (total): {a}\n'
        text += f'Ano do primeiro registro: {a}\n'
        text += f'Ano do último registro: {a}'

        console.print(Panel(
            Text(text),
            title='Overview'
        ))

    def acoes(self):
        sair = False

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
        input('Consultar forename... ')

    def relatorios(self):
        sair = False

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
