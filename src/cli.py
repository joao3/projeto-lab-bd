from db import Db

def menu(db):
    sair = False
    while not sair:
        print('1 - Fazer login')
        print('0 - Sair')
        operacao = input('Insira a operação: ')

        if operacao == '1':
            login(db)    
        elif operacao == '0':
            sair = True
        else:
            print('Operação inválida')

def login(db):
    login = input('Login: ')
    senha = input('Senha: ')

    userid = db.query('SELECT LoginUser(%s, %s);', (login, senha))[0][0]
    db.commit();

    if userid == None:
        print('Credenciais inválidas')
    else:
        usertype = db.query('SELECT type FROM USERS WHERE userid = %s;', (userid,))[0][0]

        if usertype == 'Administrador':
            print('logado como adm')
        elif usertype == 'Escuderia':
            print('logado como escuderia')
        elif usertype == 'Piloto':
            print('logado como piloto')

def main():
    db = Db('f1_test', 'postgres')
    db.conectar()
    menu(db)
    db.desconectar()

if __name__ == '__main__':
    main()