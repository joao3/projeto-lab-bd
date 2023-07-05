from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.table import Table

console = Console()

class Piloto:

    def __init__(self, db, userid):
        self.db = db
        self.userid = userid

        # Pega o id da ta bela de piloto
        self.originalid = db.query("SELECT originalid FROM USERS WHERE userid = %s", (self.userid,))[0][0]
        self.db.commit()

        self.acoes()


    def overview(self): 
        # Imprime o "header".
        console.clear()
        console.print(Panel(Text('Piloto', justify='center')))

        # Pega os dados do banco.
        nome = self.db.query('SELECT NomePiloto(%s)', (self.originalid, ))[0][0]
        vitorias = self.db.query('SELECT VitoriasPiloto(%s)', (self.originalid, ))[0][0]
        anos_registro = self.db.query('SELECT * FROM AnosRegistroPiloto(%s)', (self.originalid, ))[0]
        self.db.commit()

        # Monta a string e imprime no console.
        text = f'Nome completo: {nome}\n'
        text += f'Quantidade de vitórias: {vitorias}\n'
        text += f'Ano do primeiro registro: {anos_registro[0]}\n'
        text += f'Ano do último registro: {anos_registro[1]}'

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

        # Menu de relatórios.
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
        # Pega os dados do banco.
        resultado = self.db.query('SELECT * FROM VitoriasPilotoRelatorio(%s)', (self.originalid, ))
        self.db.commit()

        if resultado == []:
            input('Nenhum resultado encontrado, pressione enter para voltar...')
            return

        # Monta a tabela e imprime no console.
        table = Table(*['Ano', 'Corrida', 'Vitórias'], title='Vitórias do piloto')
        for linha in resultado:
            ano = linha[0].__str__()
            nome = linha[1].__str__()
            quantidade = linha[2].__str__()
            
            # Se a segunda coluna é nula, corresponde ao colapso das tuplas.
            if linha[1] == None:
                nome = 'Total'
            if linha[0] == None:
                ano = 'Todos'

            table.add_row(ano, nome, quantidade)

        console.clear()
        console.print(table)
        input('Pressione enter para voltar... ')

    def quantidade_resultados(self):
        # Pega os dados do banco.
        resultado = self.db.query('SELECT * FROM ResultadosPiloto(%s)', (self.originalid, ))
        self.db.commit()

        if resultado == []:
            input('Nenhum resultado encontrado, pressione enter para voltar...')
            return

        # Monta a tabela e imprime no console.
        table = Table(*['Status', 'Contagem'], title='Quantidade de resultados')
        for linha in resultado:
            table.add_row(linha[0].__str__(), linha[1].__str__())

        console.clear()
        console.print(table)
        input('Pressione enter para voltar... ')
