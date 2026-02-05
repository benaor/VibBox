#!/usr/bin/env bash
# =============================================================================
# VibBox - Utility Functions
# =============================================================================
#
# Description:
#   Fonctions utilitaires utilisées dans tout le projet : logging, validation,
#   manipulation de chaînes, etc.
#
# Dépendances:
#   - constants.sh (pour les couleurs)
#
# =============================================================================

# -----------------------------------------------------------------------------
# Fonctions de logging prévues:
# -----------------------------------------------------------------------------

# log_info()
#   Affiche un message d'information (bleu)
#   Args: $1 = message

# log_success() / log_ok()
#   Affiche un message de succès (vert)
#   Args: $1 = message

# log_warning() / log_warn()
#   Affiche un message d'avertissement (jaune)
#   Args: $1 = message

# log_error()
#   Affiche un message d'erreur (rouge)
#   Args: $1 = message

# log_debug()
#   Affiche un message de debug (magenta) - seulement si DEBUG=1
#   Args: $1 = message

# log_step()
#   Affiche une étape en cours (cyan)
#   Args: $1 = message

# -----------------------------------------------------------------------------
# Fonctions utilitaires prévues:
# -----------------------------------------------------------------------------

# die()
#   Affiche un message d'erreur et quitte avec un code d'erreur
#   Args: $1 = message, $2 = code de sortie (optionnel, défaut: 1)

# confirm()
#   Demande une confirmation à l'utilisateur
#   Args: $1 = message de confirmation
#   Return: 0 si oui, 1 si non

# is_command_available()
#   Vérifie si une commande est disponible dans le PATH
#   Args: $1 = nom de la commande
#   Return: 0 si disponible, 1 sinon

# require_command()
#   Vérifie qu'une commande est disponible, sinon quitte avec erreur
#   Args: $1 = nom de la commande, $2 = message d'erreur (optionnel)

# trim()
#   Supprime les espaces en début et fin de chaîne
#   Args: $1 = chaîne
#   Return: chaîne trimée (stdout)

# to_lowercase()
#   Convertit une chaîne en minuscules
#   Args: $1 = chaîne
#   Return: chaîne en minuscules (stdout)

# generate_id()
#   Génère un identifiant unique court
#   Return: identifiant (stdout)

# is_absolute_path()
#   Vérifie si un chemin est absolu
#   Args: $1 = chemin
#   Return: 0 si absolu, 1 sinon

# resolve_path()
#   Résout un chemin relatif en chemin absolu
#   Args: $1 = chemin
#   Return: chemin absolu (stdout)

# spinner()
#   Affiche un spinner pendant l'exécution d'une commande
#   Args: $1 = PID du processus, $2 = message (optionnel)
