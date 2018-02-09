# ------------------------------------------------------------------------------
#  de.msg
#  This file is part of Unifix BWidget Toolkit
#  Definition of de translation
# ------------------------------------------------------------------------------

# --- symbolic names of buttons ------------------------------------------------

::msgcat::mcset de {&Abort} {&Abbrechen}
::msgcat::mcset de {&Retry} {&Wiederholen}
::msgcat::mcset de {&Ignore} {&Ignorieren}
::msgcat::mcset de {&OK} {&OK}
::msgcat::mcset de {&Cancel} {&Abbrechen}
::msgcat::mcset de {&Yes} {&Ja}
::msgcat::mcset de {&No} {&Nein}

# --- symbolic names of label of SelectFont dialog ----------------------------

::msgcat::mcset de {Bold} {Fett}
::msgcat::mcset de {Italic} {Kursiv}
::msgcat::mcset de {Underline} {Unterstrichen}
::msgcat::mcset de {Overstrike} {Durchgestrichen}
::msgcat::mcset de {&Font} {&Schriftart}
::msgcat::mcset de {&Size} {S&chriftgrad}
::msgcat::mcset de {St&yle} {Sc&hriftschnitt}
::msgcat::mcset de {&Color...} {&Farbe...}

# --- symbolic names of label of PasswdDlg dialog -----------------------------

::msgcat::mcset de {&Login} {&Login}
::msgcat::mcset de {&Password} {&Password}

# --- resource for SelectFont dialog ------------------------------------------

::msgcat::mcset de {Font selection} {Schrift Auswahl}
::msgcat::mcset de {Sample text} {Beispieltext}

# --- resource for MessageDlg dialog ------------------------------------------

::msgcat::mcset de {Message} {Meldung}
::msgcat::mcset de {Information} {Hinweis}
::msgcat::mcset de {Question} {Frage}
::msgcat::mcset de {Warning} {Warnung}
::msgcat::mcset de {Error} {Fehler}

# --- resource for PasswdDlg dialog -------------------------------------------

::msgcat::mcset de {Enter login and password} {Enter login and password}

# --- symbolic names of label of SelectColor dialog ----------------------------

::msgcat::mcset de {Base colors} {Grundfarben}
::msgcat::mcset de {User colors} {Benutzerdefinierte Farben}
::msgcat::mcset de {Your Selection} {Gewählte Farbe}
::msgcat::mcset de {Color Selectors} {Farbraum}

# --- dynamic help text for SelectColor dialog. Lines 75 chars max, split by '\n'.

::msgcat::mcset de {Click or drag the mouse in the Color Selectors to choose a color.\nIf the selected color remains black, regardless of what you\ndo in the left-hand Color Selector (for hue and saturation), check\nthe position of the pointer in the right-hand Color Selector\n(for brightness).\n\nClick one of the "Base colors" to read a value from this palette.\n\nClick one of the "User colors" to read a value from this palette,\nor to write to the palette if the color is blank. If you then\nuse the Color Selectors to change the color, your choice will be\nwritten to this (User) palette color until you select another\n(Base or User) palette color.} {Um eine Farbe zu wählen bitte im Farbraum und im Helligkeitsregler\nklicken oder ziehen. Bleibt die gewählte Farbe wieder erwarten schwarz,\nso muß die Helligkeit ganz rechts erhöht werden.\n\nMit einem Klick auf die Grundfarbenpalette kann diese gewählt werden.\n\nEin benutzerdefinierter Farbspeicher kann durch einen Klick selektiert\nwerden. Ab dann wird jede Farbveränderung auch in den Farbspeicher\n geschrieben.}
::msgcat::mcset de {Click in the text entry window in the left of the "Your\nSelection" area.\n\nType the color that you want in hexadecimal RGB format.\nWhenever the number of hexadecimal digits is a multiple\nof 3, the color value is valid and will be copied to the\nother parts of the Color Selector.\n\nLeave the text entry window by clicking anywhere else,\nor by pressing the "Escape" or "Return" key. The text\nentry window will then display the color in 24-bit RGB\nformat, although internally the Color Selector uses\n48-bit colors.\n\nWhen the text entry widget does not have keyboard focus\n(i.e. does not show a cursor), the "Return" and "Escape"\nkeys do the same as the "OK" and "Cancel" buttons,\nrespectively.} {Aktivieren sie das Texteingabefenster mit einem Klick oder mit der\nTabulatortaste. Eine Farbe kann als RGB-Wert eingegeben mit 3 oder 6\nhexadezimalen Ziffern eingegeben werden.\n\nDie Eingabe kann mit der Escape- oder Eingabetaste abgeschlossen werden.\n\nAusserhalb des Eingabefensters wird der Dialog mit der Eingabetaste\nbestätigt und mit der Escapetaste zurückgenommen.}
