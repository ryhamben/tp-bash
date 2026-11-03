
#!/bin/bash

SEUIL=${1:-80}

UTILISATION=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')

if [ -z "$UTILISATION" ]; then
    echo "Erreur : impossible de déterminer l'utilisation du disque."
    exit 1
fi

echo "Espace disque utilisé : ${UTILISATION}%"
echo "Seuil configuré : ${SEUIL}%"

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : le seuil d'utilisation est atteint ou dépassé."
else
    echo "OK : l'utilisation du disque est sous le seuil."
fi

exit 0
