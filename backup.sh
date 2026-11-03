
#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOSSIER="${1:-}"

if [ -z "$DOSSIER" ]; then
    echo "Usage : $0 <dossier_a_sauvegarder>" >&2
    exit 1
fi

if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

BACKUP_DIR="$SCRIPT_DIR/backups"
mkdir -p "$BACKUP_DIR"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$BACKUP_DIR/backup_${DATE}.tar.gz"

echo "Début de la sauvegarde de : $DOSSIER"

tar -czf "$ARCHIVE" -C "$DOSSIER" .

echo "Sauvegarde créée : $ARCHIVE"

for fichier in "$BACKUP_DIR"/*.tar.gz; do
    [ -f "$fichier" ] || continue

    if [ "$fichier" != "$ARCHIVE" ] &&
       find "$fichier" -type f -mtime +7 -print -quit | grep -q .; then
        echo "Suppression de l'ancienne sauvegarde : $fichier"
        rm -- "$fichier"
    fi
done

echo "Sauvegarde terminée avec succès."
