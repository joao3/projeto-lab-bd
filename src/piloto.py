from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.table import Table

console = Console()

class Piloto:

    def __init__(self, db, userid):
        self.db = db
        self.userid = userid
        self.originalid = db.query("SELECT originalid FROM USERS WHERE userid = %s", (self.userid,))[0][0]
        self.nome = self.db.query("SELECT forename || ' ' || surname FROM driver WHERE driverid = %s;", (self.originalid,))[0][0]
        self.db.commit()

        self.acoes()


    def overview(self):
        console.clear()

        console.print(Panel(Text('Piloto', justify='center')))

        a = 'banco'

        text = f'Nome completo: {self.nome}\n'
        text += f'Quantidade de vitórias: {a}\n'
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
            print('0 - Sair')

            operacao = input('Insira a operação: ')

            if operacao == '1':
                self.relatorios()
            elif operacao == '0':
                sair = True
            else:
                input('Operação inválida, pressione enter para voltar... ')


    def relatorios(self):
        sair = False

        while not sair:
            console.clear()
            console.print(Panel(Text('Relatórios', justify='center')))
            print('1 - Quantidade de vitórias')
            print('2 - Quantidade de resultados')
            print('0 - Sair')

            operacao = input('Insira a operação: ')

            if operacao == '1':
                self.quantidade_vitorias()
            elif operacao == '2':
                self.quantidade_resultados()
            elif operacao == '0':
                sair = True
            else:
                input('Operação inválida, pressione enter para voltar... ')


    def quantidade_vitorias(self):
        print('relatorio vitorias') # pegar do banco

    def quantidade_resultados(self):
        resultado = self.db.query('SELECT s.status, count(*) FROM results r JOIN status s ON r.statusid = s.statusid  WHERE driverid = %s GROUP BY s.status;', (self.originalid,))
        self.db.commit()

        table = Table(*['Status', 'Contagem'], title='Quantidade de resultados')
        for linha in resultado:
            table.add_row(linha[0].__str__(), linha[1].__str__())

        console.clear()
        console.print(table)
        input('Pressione enter para voltar... ')
