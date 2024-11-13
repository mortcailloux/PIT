# Trouvez le fichier qui contient le mot !
Le jeu est assez simple, le script va créer des fichiers avec des noms aléatoires mais ces fichiers contiennent chacun un mot.
Le but va donc être de trouver le fichier qui contient le mot indiqué (mot aléatoire).
Il n'y a aucune permission accordée pour accéder au dossier donc vous allez devoir vous débrouiller vous-même !

## Lancer le jeu
Pour lancer le jeu, rien de plus simple !
Ecrivez simplement ./script.sh en n'oubliant pas de donner les permissions d'administrateur au préalable !

# Fonctionnement du programme:
- On crée le dossier secret et on se met toutes les permissions (chmod 700)
- On génère d'abord une liste de mots à partir d'une page HTML qui contient Lorem Ipsum (avec un cURL et en excluant au maximum les balises HTML)
- On élimine ensuite les doublons des mots en les stockant dans un ensemble
- On vérifie s'il y a assez de mots uniques pour générer 100 fichiers (c'est plus pour le debug)
- On génère ensuite les fichiers en écrivant les mots de lorem ipsum dedans et en générant des noms de fichiers totalement aléatoires<;
- On récupère un mot aléatoire dans la liste de mots et on récupère ensuite le fichier dans lequel il se trouve
- On enlève toutes les permissions (chmod 000)
- On laisse l'utilisateur chercher les fichiers etc
- On vérifie que la réponse est bonne et on met un message approprié
- On se remet un chmod 700 et on supprime le dossier secret (rm -rf secret)


#Solution
