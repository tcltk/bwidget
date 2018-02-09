# ------------------------------------------------------------------------------
#  fr.msg
#  This file is part of Unifix BWidget Toolkit
#  Definition of fr translation
# ------------------------------------------------------------------------------

# --- symbolic names of buttons ------------------------------------------------

::msgcat::mcset fr {&Abort} {A&bandonner}
::msgcat::mcset fr {&Retry} {&Réessayer}
::msgcat::mcset fr {&Ignore} {&Ignorer}
::msgcat::mcset fr {&OK} {&OK}
::msgcat::mcset fr {&Cancel} {&Annuler}
::msgcat::mcset fr {&Yes} {&Oui}
::msgcat::mcset fr {&No} {&Non}

# --- symbolic names of label of SelectFont dialog ----------------------------

::msgcat::mcset fr {Bold} {&Gras}
::msgcat::mcset fr {Italic} {&Italique}
::msgcat::mcset fr {Underline} {&Souligné}
::msgcat::mcset fr {Overstrike} {&Barré}
::msgcat::mcset fr {&Font} {&Police}
::msgcat::mcset fr {&Size} {&Taille}
::msgcat::mcset fr {St&yle} {St&yle}
::msgcat::mcset fr {&Color...} {&Couleur...}

# --- symbolic names of label of PasswdDlg dialog -----------------------------

::msgcat::mcset fr {&Login} {Nom de l'&utilisateur}
::msgcat::mcset fr {&Password} {Mot de &passe}

# --- resource for SelectFont dialog ------------------------------------------

::msgcat::mcset fr {Font selection} {Sélection d'une police}
::msgcat::mcset fr {Sample text} {Texte d'exemple}

# --- resource for MessageDlg dialog ------------------------------------------

::msgcat::mcset fr {Message} {Message}
::msgcat::mcset fr {Information} {Information}
::msgcat::mcset fr {Question} {Question}
::msgcat::mcset fr {Warning} {Attention}
::msgcat::mcset fr {Error} {Erreur}

# --- resource for PasswdDlg dialog -------------------------------------------

::msgcat::mcset fr {Enter login and password} {Entrez le login et le mot de passe}

# --- symbolic names of label of SelectColor dialog ----------------------------

::msgcat::mcset fr {Base colors} {Couleurs de base}
::msgcat::mcset fr {User colors} {Couleurs utilisateur}
::msgcat::mcset fr {Your Selection} {Votre sélection}
::msgcat::mcset fr {Color Selectors} {Sélecteur de couleurs}

# --- dynamic help text for SelectColor dialog. Lines 75 chars max, split by '\n'.

::msgcat::mcset fr {Click or drag the mouse in the Color Selectors to choose a color.\nIf the selected color remains black, regardless of what you\ndo in the left-hand Color Selector (for hue and saturation), check\nthe position of the pointer in the right-hand Color Selector\n(for brightness).\n\nClick one of the "Base colors" to read a value from this palette.\n\nClick one of the "User colors" to read a value from this palette,\nor to write to the palette if the color is blank. If you then\nuse the Color Selectors to change the color, your choice will be\nwritten to this (User) palette color until you select another\n(Base or User) palette color.} {Cliquez ou déplacez la souris dans la palette pour choisir une couleur.\nSi la couleur affichée reste noire quelle que soit la sélection dans la palette (teinte et\nsaturation), vérifiez la position du pointeur dans le sélecteur de droite (luminosité).\n\nCliquez sur l'une des "Couleurs de base" pour la sélectionner.\n\nCliquez sur l'une des "Couleurs utilisateurs" pour la sélectionner, ou pour la\nsauver dans la palette utilisateur dans une case blanche. Les modifications via le\nsélecteur de couleurs sont alors propagées dans la case sélectionnée de la palette\nutilisateur jusqu'à ce qu'une autre couleur (de base ou utilisateur) soit sélectionnée.}
::msgcat::mcset fr {Click in the text entry window in the left of the "Your\nSelection" area.\n\nType the color that you want in hexadecimal RGB format.\nWhenever the number of hexadecimal digits is a multiple\nof 3, the color value is valid and will be copied to the\nother parts of the Color Selector.\n\nLeave the text entry window by clicking anywhere else,\nor by pressing the "Escape" or "Return" key. The text\nentry window will then display the color in 24-bit RGB\nformat, although internally the Color Selector uses\n48-bit colors.\n\nWhen the text entry widget does not have keyboard focus\n(i.e. does not show a cursor), the "Return" and "Escape"\nkeys do the same as the "OK" and "Cancel" buttons,\nrespectively.} {Cliquez dans la zone de saisie à gauche, dans la zone "Votre sélection".\n\nEntrez la couleur désirée au format RGB hexadécimal.\nLa valeur est validée lorsque le nombre de chiffres hexadécimaux est un multiple de 3.\nElle est alors propagée aux autres zones du sélecteur de couleurs.\n\nLa zone de saisie peut être quittée en cliquant n'importe où ailleurs ou en appuyant sur la\ntouche "Escape" ou "Entrée" du clavier. Bien que le sélecteur de couleurs utilise\n48 bits en interne, la zone de saisie affichera alors la couleur au format RGB en\nhexadécimal sur 24 bits.\n\nLorsque la zone de saisie n'a pas le focus (i.e. ne montre pas le curseur), les touches\n"Entrée" et "Escape" ont la même fonction que les boutons "OK" et "Annuler" respectivement.}
