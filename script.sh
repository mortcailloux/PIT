#!/bin/bash

# Création du dossier "secret" sans les permissions de lecture
mkdir -p secret
chmod 700 secret

# Fonction pour générer une liste de mots uniques à partir de Lorem Ipsum
generate_unique_lorem_ipsum_words() {
    # Télécharger le texte Lorem Ipsum, supprimer les balises HTML, convertir en minuscules,
    # séparer les mots et les stocker dans un tableau
    all_words=($(curl -s https://www.lipsum.com/feed/html | \
        sed 's/<[^>]*>//g' | \
        tr '[:upper:]' '[:lower:]' | \
        tr -s ' ' '\n' | \
        grep -v '^$'))

    # Créer un ensemble (HashSet) pour stocker les mots uniques
    unique_words=()
    for word in "${all_words[@]}"; do
        if [[ ! " ${unique_words[@]} " =~ " ${word} " ]]; then
            unique_words+=("$word")
        fi
    done

    # Vérification si le nombre de mots uniques est suffisant
    if [[ ${#unique_words[@]} -lt 100 ]]; then
        echo "Erreur : Pas assez de mots uniques pour créer 100 fichiers."
        exit 1
    fi

    # Mélange des mots (sans shuf, en utilisant une méthode simple)
    for i in $(seq 0 $((${#unique_words[@]} - 1))); do
        j=$((RANDOM % (${#unique_words[@]} - i) + i))
        tmp=${unique_words[$i]}
        unique_words[$i]=${unique_words[$j]}
        unique_words[$j]=$tmp
    done

    echo "${unique_words[@]}"
}

# Fonction pour générer un nom de fichier aléatoire
generate_filename() {
    local length=$1
    tr -dc 'a-zA-Z0-9' </dev/urandom | head -c "$length"
}

# Fonction pour créer des fichiers avec des mots Lorem Ipsum uniques
create_files() {
    local total_files=$1
    local unique_words=("${@}")
    local num_words=${#unique_words[@]}

    for ((i=0; i<total_files; i++)); do
        local file_name
        local word

        # Générer un nom de fichier unique
        while : ; do
            file_name=$(generate_filename 8).txt
            if [[ ! -e "secret/$file_name" ]]; then
                break
            fi
        done

        # Sélectionner un mot unique à partir de la liste mélangée
        word=${unique_words[$i]}

        # Écrire le mot dans le fichier
        echo "$word" > "secret/$file_name"

        # Stocker le nom du fichier et le mot dans un tableau pour vérification
        file_list+=("$file_name:$word")
    done
}

# Générer la liste de mots Lorem Ipsum uniques
unique_words=($(generate_unique_lorem_ipsum_words))

# Définir le nombre de fichiers à créer
num_files=100

# Créer les fichiers avec des mots Lorem Ipsum uniques
create_files "$num_files" "${unique_words[@]}"

# Choisir un mot aléatoire parmi ceux générés et s'assurer qu'il est dans un fichier
chosen_entry=${file_list[$RANDOM % ${#file_list[@]}]}
chosen_file=${chosen_entry%%:*}  # Extraire le nom du fichier
chosen_word=${chosen_entry##*:}   # Extraire le mot

# Changer les permissions du dossier "secret" à 000
chmod 000 secret

# Demander à l'utilisateur de localiser ce mot
echo "Bienvenue au jeu de localisation de mot !"
echo "Je vais choisir un mot au hasard et il se trouve dans l'un des fichiers dans le dossier 'secret'."
echo "Votre mission est de trouver le nom du fichier qui contient ce mot."
echo "Bonne chance !"

# L'utilisateur doit deviner le nom du fichier
echo -n "Quel fichier contient le mot '$chosen_word' ? (donne le nom du fichier sans extension) : "
read user_guess

# Vérification de la réponse de l'utilisateur
if [[ "${chosen_file%.txt}" == "$user_guess" ]]; then
    echo "Bravo ! Vous avez trouvé le fichier contenant le mot."
else
    echo "Désolé, ce n'est pas le bon fichier. Le mot se trouve dans le fichier '$chosen_file'."
fi

# Restaurer les permissions du dossier "secret" et supprimer le dossier
chmod 777 secret
rm -rf secret
