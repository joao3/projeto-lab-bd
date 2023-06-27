from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.table import Table

console = Console()

class Admin:

    def __init__(self, db):
        self.db = db

        self.acoes()


    def overview(self):
        console.clear()
        console.print(Panel(Text('Admin', justify='center')))

        a = 'banco'

        text = f'Quantidade de pilotos: {a}\n'
        text += f'Quantidade de escuderias: {a}\n'
        text += f'Quantidade de corridas: {a}\n'
        text += f'Quantidade de temporadas: {a}'

        console.print(Panel(
            Text(text),
            title='Overview'
        ))

    def acoes(self):
        sair = False

        while not sair:
            self.overview()
            print('1 - Ir para relatórios')
            print('2 - Cadastrar escuderia')
            print('3 - Cadastrar piloto')
            print('0 - Sair')

            operacao = input('Insira a operação: ')

            if operacao == '1':
                self.relatorios()
            elif operacao == '2':
                self.cadastrar_escuderia()
            elif operacao == '3':
                self.cadastrar_piloto()
            elif operacao == '0':
                sair = True
            else:
                input('Operação inválida, pressione enter para voltar... ')

    def cadastrar_escuderia(self):
        input('Cadastrar escuderia... ')

    def cadastrar_piloto(self):
        input('Cadastrar piloto... ')

    def relatorios(self):
        sair = False

        while not sair:
            console.clear()
            console.print(Panel(Text('Relatórios', justify='center')))
            print('1 - Quantidade de resultados')
            print('2 - Aeroportos próximos a cidade')
            print('0 - Sair')

            operacao = input('Insira a operação: ')

            if operacao == '1':
                self.quantidade_resultados()
            elif operacao == '2':
                self.aeroportos_cidade()
            elif operacao == '0':
                sair = True
            else:
                input('Operação inválida, pressione enter para voltar... ')

    def quantidade_resultados(self):
        input('Quantidade resultados... ')

    def aeroportos_cidade(self):
        input('Aeroportos cidade... ')