#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/ci.log"
REPO_URL="${1:-}"
WORK_DIR="$SCRIPT_DIR/ci-workdir"

# Fonction de journalisation
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Gestion des erreurs inattendues
on_error() {
    local code=$?
    log "ERREUR : échec à la ligne ${BASH_LINENO[0]:-inconnue} (code $code)"
    exit "$code"
}
trap on_error ERR

# Vérification de l'argument
if [ -z "$REPO_URL" ]; then
    log "ERREUR : URL du dépôt manquante."
    log "Utilisation : ./ci.sh <URL_DU_DEPOT>"
    exit 1
fi

log "===== DEBUT DU PIPELINE CI ====="

# Clonage ou mise à jour du dépôt
if [ -d "$WORK_DIR/.git" ]; then
    log "Mise à jour du dépôt existant..."
    git -C "$WORK_DIR" pull --ff-only
elif [ -e "$WORK_DIR" ]; then
    log "ERREUR : le dossier de travail existe mais n'est pas un dépôt Git."
    exit 1
else
    log "Clonage du dépôt..."
    git clone "$REPO_URL" "$WORK_DIR"
fi

# Fonction d'exécution des tests
run_tests() {
    local failed=0

    log "Début des tests..."

    for script in check_disk.sh backup.sh ci.sh; do
        if [ ! -f "$WORK_DIR/$script" ]; then
            log "ECHEC : fichier $script introuvable."
            failed=1
        elif [ ! -x "$WORK_DIR/$script" ]; then
            log "ECHEC : $script n'est pas exécutable."
            failed=1
        elif bash -n "$WORK_DIR/$script"; then
            log "SUCCES : $script, syntaxe correcte et permission exécutable."
        else
            log "ECHEC : erreur de syntaxe dans $script."
            failed=1
        fi
    done

    return "$failed"
}

# Résultat final du pipeline
if run_tests; then
    log "===== PIPELINE TERMINE AVEC SUCCES ====="
    exit 0
else
    log "===== PIPELINE TERMINE AVEC ECHEC ====="
    exit 1
fi
