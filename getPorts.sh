#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "Debe ejecurar el script como root"
	echo "Ejemplo: sudo $0 192.168.62.135"
	exit 1
fi
if [ $# -eq 0 ]; then
	echo "Este script le listará los puertos abieros de un equipo"
	echo "Modo de uso: sudo $0 <Ip>"
	echo "Ejemplo: sudo $0 192.168.62.135"
	exit 1
fi

ip=$1
comando="nmap -n -sS -p- -T4 -O -A $ip -oG resTmp"
echo "Ejecutando el comando $comando"
echo "Por favor espere ..."
ejec=$($comando)
resultado1=$(cat resTmp | grep -oE "[0-9]{1,5}/open" | cut -d "/" -f 1 | sed 's/ /\'$'\n''/g')
resultado2=$(cat resTmp | grep -oE "[0-9]{1,5}/open" | cut -d "/" -f 1 | xargs | tr " " ",")
echo "::::::<Resultados>::::::"
if [ -z "$resultado1" ]; then
	echo "No hubo resultados para la ip: $ip"
	exit 1
fi
echo "Formato lista:"
echo "$resultado1"
echo "Formato lista elementos: $resultado2"
