# Mood & Metrics

Application mobile Flutter de journal personnel pour suivre son humeur, son poids et identifier les facteurs qui influencent son bien-être au quotidien.

## Auteurs

Projet scolaire réalisé en binôme dans le cadre du module Flutter.

- **Marion CANDUSSO** — Paramètres, thème, notifications, shell applicatif
- **Titouan CHAUCHE** — Journal, analyse, base de données

## Fonctionnalités

- Enregistrer une entrée quotidienne contenant son humeur (5 niveaux), son poids (optionnel), des notes et des tags (facteurs influents : sport, alcool, travail, famille, stress, sortie, mauvais sommeil)
- Visualiser ses entrées passées dans un journal
- Analyser statistiquement son humeur sur 3 périodes (7, 30 et 90 jours) : humeur moyenne, répartition par mood, meilleur/pire jour, fréquence des tags, impact des tags sur l'humeur
- Personnaliser le thème de l'application (clair / sombre / système)
- Activer un rappel quotidien par notification locale à l'heure de son choix

Toutes les données sont stockées **localement** sur l'appareil de l'utilisateur.

## Architecture

Le projet applique une architecture en couches stricte : **UI → Bloc → Repository → DataSource**.

Cette séparation permet notamment de remplacer la source de données locale par une source distante (API en ligne) dans une V2, **sans modifier les Blocs ni l'UI**. Seule l'implémentation du `DataSource` changerait, car les Repositories dépendent d'une interface abstraite (inversion des dépendances).


## Technologies et dépendances

| Package | Rôle |
|---|---|
| `flutter_bloc` | Gestion d'état réactive (pattern Bloc) |
| `sqflite` | Base de données relationnelle locale (entrées du journal) |
| `shared_preferences` | Stockage clé/valeur pour les paramètres |
| `flutter_local_notifications` | Notifications locales pour les rappels quotidiens |
| `timezone` + `flutter_timezone` | Planification de notifications dans le fuseau horaire local |
| `fl_chart` | Graphiques (pie chart, bar chart) pour l'onglet Analyse |
| `flutter_staggered_grid_view` | Grille en mosaïque pour le journal |
| `intl` | Formatage et parsing des dates |

### Choix techniques justifiés

- **SharedPreferences** pour les paramètres : données simples de type clé/valeur (thème, heure de rappel, activation), pas de relations à gérer, accès synchrone et léger.
- **SQLite (sqflite)** pour le journal : données structurées, nombreuses entrées, besoin de requêtes filtrées par date pour l'analyse → une base relationnelle s'impose.
- **Bloc** plutôt que Provider ou Riverpod : pattern imposé par l'énoncé, impose une séparation claire entre événements (intentions utilisateur) et états (rendu UI).

## Installation

### Prérequis

- Flutter SDK ≥ 3.10.7
- Un émulateur Android ou un appareil physique (iOS ou Android)

### Lancement

```bash
git clone <url-du-repo>
cd Mood-Metrics
flutter pub get
flutter run
```

## Fonctionnalités par onglet

### Journal
Liste des entrées affichée en grille mosaïque. Un bouton flottant `+` ouvre une boîte de dialogue pour créer une nouvelle entrée du jour (humeur, poids, notes, tags).

### Analyse
Trois périodes d'analyse sélectionnables (7, 30, 90 jours) :
- Humeur moyenne sur la période
- Graphique en barres : impact moyen des tags sur l'humeur
- Cartes du meilleur et du pire jour
- Graphique en camembert : répartition des humeurs
- Graphique en camembert : fréquence des tags

L'écran se met à jour automatiquement dès qu'une entrée est ajoutée/modifiée/supprimée dans l'onglet Journal (les données circulent via un `Stream` entre le `JournalRepository` et l'`AnalyticsBloc`).

### Paramètres
- Sélection du thème (clair / sombre / système) via `SegmentedButton`
- Activation/désactivation du rappel quotidien
- Choix de l'heure du rappel via `TimePicker`
- Bouton de test pour déclencher une notification immédiate
