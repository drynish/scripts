#!/usr/bin/python3
import os, sys, subprocess
from pathlib import Path

dest = "/Volumes/External/drynish/git/ecole"

if len(sys.argv) != 2:
    print ("Usage: moveToGitlab.py fichier_ou_répertoire_source")
    exit(1)

source = sys.argv[1]
parts = Path(source).parts

if os.path.exists(source):
    if ( parts.index("cours") > 0 ):
        stripped_folder = Path(*parts[parts.index("cours")+1:])
        
        destination = os.path.join(dest, stripped_folder)      
                
        if os.path.isfile(source):
            # Créer le ou les répertoire(s) parent(s) du répertoire de destination
            subprocess.run(["mkdir", "-p", os.path.dirname(destination)])
            # Copier le fichier de destination vers le répertoire de destination
            subprocess.run(["ln", source , destination])
        
        if os.path.isdir(source):
            # Créer le répertoire de destination 
            subprocess.run(["mkdir", "-p", destination])

            # Pour chaque fichier
            for filename in os.listdir(source):

                # Copier le fichier du répertoire source à la destination
                subprocess.run(["ln" , os.path.join(source, filename), destination])

    else:
        print ("Mauvais travail")
        exit (1)
else:

    exit(1)