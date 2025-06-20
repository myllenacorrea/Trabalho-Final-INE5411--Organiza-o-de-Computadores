import time
import datetime

# Dicionários globais para preços e nomes
preco_combustivel = {1: 5.10, 2: 5.80, 3: 4.20}
nomes_combustiveis = {1: "Gasolina Comum", 2: "Gasolina Aditivada", 3: "Álcool"}

#Maria Julia
def menu():
    """Exibe o menu principal e direciona para as funções de funcionário ou cliente."""
    while True:
        print("\nMENU PRINCIPAL")
        print("1 - Funcionário")
        print("2 - Cliente")
        print("0 - Sair")
        opcao = input("Escolha uma opção: ")

        if opcao == "1":
            operador()
        elif opcao == "2":
            cliente()
        elif opcao == "0":
            print("Encerrando o sistema.")
            break
        else:
            print("Opção inválida. Tente novamente.")

#Maria Julia
def operador():
    """Permite que o funcionário altere os preços dos combustíveis."""
    while True:
        print("\nMENU FUNCIONÁRIO")
        print(f"1 - Gasolina Comum: R$ {preco_combustivel[1]:.2f}")
        print(f"2 - Gasolina Aditivada: R$ {preco_combustivel[2]:.2f}")
        print(f"3 - Álcool: R$ {preco_combustivel[3]:.2f}")
        print("0 - Voltar ao menu principal")

        escolha = input("Qual preço deseja alterar? (0 para voltar): ")

        if escolha in ["1", "2", "3"]:
            try:
                novo_preco_str = input(f"Novo preço para {nomes_combustiveis[int(escolha)]}: R$ ")
                novo_preco = float(novo_preco_str.replace(',', '.')) # Aceita vírgula ou ponto
                preco_combustivel[int(escolha)] = round(novo_preco, 2)
                print("Preço alterado com sucesso!")
            except ValueError:
                print("Valor inválido. Por favor, insira um número.")
        elif escolha == "0":
            break
        else:
            print("Opção inválida.")

#Maria Julia
def cliente():
    """Exibe o menu para o cliente escolher o combustível e o método de abastecimento."""
    while True:
        print("\nMENU CLIENTE")
        print(f"1 - {nomes_combustiveis[1]}")
        print(f"2 - {nomes_combustiveis[2]}")
        print(f"3 - {nomes_combustiveis[3]}")
        print("0 - Voltar ao menu principal")

        tipo_str = input("Escolha o tipo de combustível: ")

        if tipo_str == "0":
            break

        if tipo_str not in ["1", "2", "3"]:
            print("Opção inválida. Tente novamente.")
            continue
        
        tipo = int(tipo_str)

        print(f"Preço atual: R$ {preco_combustivel[tipo]:.2f}")
        print("1 - Abastecer por valor (R$)")
        print("2 - Abastecer por litros")
        
        metodo = input("Escolha o método: ")
        if metodo in ["1", "2"]:
            abastecer(tipo, metodo)
        else:
            print("Método inválido.")

#Myllena
def abastecer(tipo_combustivel, modo):
    """Processa o abastecimento com base na escolha do cliente."""
    preco_litro = preco_combustivel[tipo_combustivel]
    total_litros = 0
    total_pagar = 0

    try:
        if modo == "1":  # Abastecer por valor
            valor_desejado = float(input("Digite o valor a ser abastecido (R$): "))
            total_litros = valor_desejado / preco_litro
            total_pagar = valor_desejado
        elif modo == "2":  # Abastecer por litros
            litros_desejados = float(input("Digite a quantidade em litros: "))
            total_litros = litros_desejados
            total_pagar = litros_desejados * preco_litro
        else:
            return # Sai da função se o modo for inválido

        print(f"\nIniciando abastecimento...")
        print(f"Total a abastecer: {total_litros:.2f} L")
        print(f"Valor total: R$ {total_pagar:.2f}")
        print("-----------------------------------------")

        # Simulação do abastecimento
        litros_inteiros = int(total_litros)
        litros_fracionados = total_litros % 1

        for i in range(1, litros_inteiros + 1):
            time.sleep(1)
        
        print(f"Abastecido: {total_litros:.2f} L...")

        print("\n--- ABASTECIMENTO CONCLUÍDO ---")
        gerar_cupom_fiscal(tipo_combustivel, total_litros, total_pagar)

    except ValueError:
        print("Entrada inválida. Por favor, digite um número.")

#Jessica
def gerar_cupom_fiscal(tipo_combustivel, litros, total_pagar):
    """Gera um arquivo de texto com os detalhes do abastecimento."""
    
    
    nome_combustivel = nomes_combustiveis.get(tipo_combustivel, "Desconhecido")

    conteudo = (
        "------ CUPOM FISCAL ------\n"
        f"Data: {datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n"
        "--------------------------\n"
        f"Combustível: {nome_combustivel}\n"
        f"Quantidade: {litros:.2f} litros\n"
        f"Preço por litro: R$ {preco_combustivel[tipo_combustivel]:.2f}\n"
        f"Total a pagar: R$ {total_pagar:.2f}\n"
        "--------------------------\n"
        "      Volte Sempre!       \n"
    )

    nome_arquivo = "cupom_fiscal.txt"

    try:
        with open(nome_arquivo, "w", encoding="utf-8") as arquivo:
            arquivo.write(conteudo)
        
        print(f"Cupom fiscal gerado com sucesso em: {nome_arquivo}")
    except IOError as e:
        print(f"Erro ao salvar o cupom fiscal: {e}")


def main():
    """Função principal que inicia o programa."""
    menu()

if __name__ == "__main__":
    main()
