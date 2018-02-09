# ------------------------------------------------------------------------------
#  da.msg
#  This file is part of Unifix BWidget Toolkit
#  Definition of da translation
# ------------------------------------------------------------------------------

# --- symbolic names of buttons -----------------------------------------------

::msgcat::mcset da {&Abort} {&Annullér}
::msgcat::mcset da {&Retry} {P&røv igen}
::msgcat::mcset da {&Ignore} {&Ignorer}
::msgcat::mcset da {&OK} {&OK}
::msgcat::mcset da {&Cancel} {&Cancel}
::msgcat::mcset da {&Yes} {&Ja}
::msgcat::mcset da {&No} {&Nej}

# --- symbolic names of label of SelectFont dialog ----------------------------

::msgcat::mcset da {Bold} {Fed}
::msgcat::mcset da {Italic} {Kursiv}
::msgcat::mcset da {Underline} {Understreg}
::msgcat::mcset da {Overstrike} {Overstreg}
::msgcat::mcset da {&Font} {&Font}
::msgcat::mcset da {&Size} {&Størrelse}
::msgcat::mcset da {St&yle} {St&il}
::msgcat::mcset da {&Color...} {F&arve...}

# --- symbolic names of label of PasswdDlg dialog -----------------------------

::msgcat::mcset da {&Login} {&Brugernavn}
::msgcat::mcset da {&Password} {&Password}

# --- resource for SelectFont dialog ------------------------------------------

::msgcat::mcset da {Font selection} {Font-valg}
::msgcat::mcset da {Sample text} {Eksempeltekst æøå}

# --- resource for MessageDlg dialog ------------------------------------------

::msgcat::mcset da {Message} {Besked}
::msgcat::mcset da {Information} {Information}
::msgcat::mcset da {Question} {Spørgsmål}
::msgcat::mcset da {Warning} {Advarsel}
::msgcat::mcset da {Error} {Fejl}

# --- resource for PasswdDlg dialog -------------------------------------------

::msgcat::mcset da {Enter login and password} {Indtast brugernavn og password}

# --- symbolic names of label of SelectColor dialog ----------------------------

::msgcat::mcset da {Base colors} {Grundfarver}
::msgcat::mcset da {User colors} {Brugerdefinerede farver}
::msgcat::mcset da {Your Selection} {Dit valg}
::msgcat::mcset da {Color Selectors} {Farvervælger}

# --- dynamic help text for SelectColor dialog. Lines 75 chars max, split by '\n'.

::msgcat::mcset da {Click or drag the mouse in the Color Selectors to choose a color.\nIf the selected color remains black, regardless of what you\ndo in the left-hand Color Selector (for hue and saturation), check\nthe position of the pointer in the right-hand Color Selector\n(for brightness).\n\nClick one of the "Base colors" to read a value from this palette.\n\nClick one of the "User colors" to read a value from this palette,\nor to write to the palette if the color is blank. If you then\nuse the Color Selectors to change the color, your choice will be\nwritten to this (User) palette color until you select another\n(Base or User) palette color.} {Klik eller træk musen i farvervælgeren for at vælge en farve.\nHvis den valgte farve altid er sort, uanset værdierne til venstre,\ntjek intensitetsværdien til højere.\n\nKlik en af "grundfarverne" for at aflæse værdierne fra paletten,\neller for at tildele en, hvis farven er sort. Hvis du efterfølgende\nbruger farvevælgeren til at ændre en farver, gemmes ændringen under\nbrugerdefinerede farver indtil en ny paletfarve er valgt.}
::msgcat::mcset da {Click in the text entry window in the left of the "Your\nSelection" area.\n\nType the color that you want in hexadecimal RGB format.\nWhenever the number of hexadecimal digits is a multiple\nof 3, the color value is valid and will be copied to the\nother parts of the Color Selector.\n\nLeave the text entry window by clicking anywhere else,\nor by pressing the "Escape" or "Return" key. The text\nentry window will then display the color in 24-bit RGB\nformat, although internally the Color Selector uses\n48-bit colors.\n\nWhen the text entry widget does not have keyboard focus\n(i.e. does not show a cursor), the "Return" and "Escape"\nkeys do the same as the "OK" and "Cancel" buttons,\nrespectively.} {Klik i tekstboksen til venstre i "dit valg" området.\n\nIndtast den ønskede farve i hexadecimalt RGB-format.\nVærdien er gyldig når den består af et antal cifre deleligt med 3,\ni så fald opdateres resten af farvervælgeren.\n\nForlad tekstboksen ved at klikke andetsteds, eller ved at taste\n"Escape" eller "Return". Tekstboksen viser efterfølgende farven i\n24-bit RGB-format, dog arbejder farvevælgeren internt med\n48-bit værdier.\n\nNår tekstboksen ikke har fokus fungerer "Return" og "Escape"\ntasterne lige som henholdsvis "OK" og "Annullér".}
