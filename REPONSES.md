# REPONSES - TP N°2 : Linux & Scripting Bash

## Exercice 2.1 - Navigation, recherche et permissions

**Question : Que donne chmod 644 sur un fichier ? Est-il exécutable par son propriétaire ?**

La commande chmod 644 attribue les permissions suivantes :
- Propriétaire : lecture et écriture (rw-).
- Groupe : lecture uniquement (r--).
- Autres utilisateurs : lecture uniquement (r--).

Le fichier n'est pas exécutable par son propriétaire, car aucun droit d'exécution (x) n'est accordé.

## Exercice 2.2 - Vérification d'espace disque

**Question : Pourquoi utilise-t-on des guillemets autour de "$UTILISATION" dans le test if ?**

Les guillemets empêchent le découpage de la valeur en plusieurs mots et évitent l'expansion des caractères spéciaux. Ils protègent également contre les valeurs vides et permettent de transmettre correctement la variable à la commande de test.

## Exercice 2.3 - Script de sauvegarde

**Question : Que se passe-t-il si on enlève set -Eeuo pipefail et que tar échoue ? Le script continue-t-il à tort ?**

Oui, le script peut continuer même si la commande tar échoue, ce qui peut entraîner la suppression de sauvegardes ou l'affichage d'un message de réussite incorrect.

L'instruction set -Eeuo pipefail améliore la gestion des erreurs :
- -e : arrête le script lorsqu'une commande échoue dans les cas concernés.
- -E : permet la transmission des pièges ERR aux fonctions et sous-shells.
- -u : signale l'utilisation de variables non définies.
- -o pipefail : détecte l'échec d'une commande dans un pipeline.

## Exercice 2.4 - Planification avec Cron

**Question : Pourquoi cron nécessite-t-il des chemins absolus alors qu'un script fonctionne très bien depuis le terminal avec des chemins relatifs ?**

Cron s'exécute dans un environnement différent de celui du terminal interactif. Son répertoire de travail et ses variables d'environnement, notamment PATH, peuvent être différents.

Les chemins absolus permettent donc de localiser précisément les scripts et les fichiers, indépendamment du répertoire courant.

## Exercice 2.5 - Mini-projet CI/CD

**Question : Quelles étapes ajouteriez-vous pour transformer ce script en un vrai pipeline CI ? Quels seraient les points de défaillance à gérer avec des codes de retour ?**

Pour transformer ce script en un véritable pipeline CI/CD, on pourrait ajouter :
- L'installation des dépendances.
- L'exécution des tests unitaires et fonctionnels.
- L'analyse de la qualité du code.
- La construction de l'application.
- Des tests de sécurité.
- Le déploiement automatique après validation.

Les principaux points de défaillance sont :
- L'échec du clonage ou de la mise à jour du dépôt.
- L'échec de l'installation des dépendances.
- L'échec des tests.
- Les erreurs de compilation ou de construction.
- Les problèmes de connexion ou d'authentification.
- Les erreurs pendant le déploiement.

Les codes de retour permettent de signaler clairement si chaque étape a réussi (0) ou échoué (valeur non nulle).
