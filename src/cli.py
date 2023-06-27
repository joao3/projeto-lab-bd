from db import Db

from rich.console import Console
from rich.panel import Panel
from rich.text import Text

from piloto import Piloto
from construtor import Construtor
from admin import Admin

console = Console()

def menu(db):
    sair = False
    while not sair:
        console.clear()
        console.print(Panel(Text('Menu', justify='center')))
        print('1 - Fazer login')
        print('0 - Sair')

        operacao = input('Insira a operação: ')

        if operacao == '1':
            login(db)
            
        elif operacao == '0':
            sair = True
            
        else:
            input('Operação inválida, pressione enter para voltar... ')

def login(db):
    console.print(Panel(Text('Login', justify='center')))
    login = input('Login: ')
    senha = input('Senha: ')

    userid = db.query('SELECT LoginUser(%s, %s);', (login, senha))[0][0]
    db.commit();

    if userid is None:
        input('Credenciais inválidas, pressione enter para voltar... ')
        
    else:
        usertype = db.query('SELECT type FROM USERS WHERE userid = %s;', (userid,))[0][0]
        db.commit();

        if usertype == 'Administrador':
            Admin(db)

        elif usertype == 'Escuderia':
            Construtor(db, userid)

        elif usertype == 'Piloto':
            Piloto(db, userid)

        return True

def main():
    db = Db('f1_test', 'postgres')
    db.conectar()
    menu(db)
    db.desconectar()

if __name__ == '__main__':
    main()
