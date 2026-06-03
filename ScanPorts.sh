#!/bin/bash

# Limpiar la pantalla
clear

# Banner en arte ASCII (Texto como imagen)
echo -e "\e[1;36m"
echo "  ____                  ____                _       "
echo " / ___|  ___ __ _ _ __ |  _ \ ___  _ __| |_ ___ "
echo " \___ \ / __/ _\` | '_ \| |_) / _ \| '__| __/ __|"
echo "  ___) | (_| (_| | | | |  __/ (_) | |  | |_\__ \\"
echo " |____/ \___\__,_|_| |_|_|   \___/|_|   \__|___/"
echo -e "\e[0m"
echo "====================================================="
echo " Detectando puertos abiertos en el sistema..."
echo "====================================================="
echo ""

# Mostrar la cabecera de la tabla
printf "%-10s %-10s %-20s\n" "PROTOCOLO" "PUERTO" "SERVICIO / PROCESO"
echo "-----------------------------------------------------"

# Obtener los puertos abiertos (TCP y UDP) en estado LISTEN o establecidos
# Se usa 'ss', se filtra con awk y se eliminan duplicados
ss -tuln | awk 'NR>1 {
    split($5, addr, ":");
    port = addr[length(addr)];
    proto = $1;
    if (port != "") {
        print proto, port;
    }
}' | sort -n -k2 | uniq | while read -r proto port; do

    # Intentar obtener el nombre del servicio asociado al puerto desde /etc/services
    service=$(grep -w "$port/$proto" /etc/services | awk '{print $1}' | head -n 1)
    
    # Si no se encuentra el servicio, mostrar "Desconocido"
    if [ -z "$service" ]; then
        service="Desconocido"
    fi

    # Imprimir los resultados formateados
    printf "%-10s %-10s %-20s\n" "${proto^^}" "$port" "$service"
done

echo ""
echo "====================================================="
echo " Escaneo finalizado."
echo "====================================================="
