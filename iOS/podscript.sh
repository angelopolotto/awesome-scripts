#!/bin/sh

# Script para pode auxiliar na atualizacao dos pods do projeto para iOS da Caixa
# Autor: Angelo Polotto
# Empresa: Tivit

while :
do
	clear
	echo '--------------------- POD CAIXA -----------------------'
	echo '--> Lista de repositorios do pod: '
	pod repo list
	echo '-------------------------------------------------------'
	
	read -p '--> Escolha uma opcao...
		 0 - para limpar todo o cache;
		 1 - para atualizar algum repositorio; 
		 2 - para instalar os pacotes;
		 3 - para remover um repositorio;
		 4 - para sair: ' option

	case $option in
	0) 
		echo '--> limpado o cache'
		pod cache clean --all
		echo '--> pronto!'
		;;
	1)
		read -p '--> Digite o nome do repositorio: ' repo
		echo "--> atualizando o repositorio: $repo"
		pod repo update $repo
		echo '--> pronto!'
		;;
	2)
		echo '--> baixando os pacotes para o projeto do diretorio atual'
		pod install
		echo '--> pronto!'
		;;
	3)
		read -p '--> Digite o nome do repositorio: ' repo
		echo "--> removendo o repositorio: $repo"
		pod repo remove $repo
		echo '--> pronto!'
		;;
	4)
		echo '-> saindo...'
		break
		;;
	*)
		echo '--> comando desconhecido'
		;;
	esac
	read -p '--> pressione ENTER para continuar...'
done
