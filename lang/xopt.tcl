# ------------------------------------------------------------------------------
# xopt.tcl
# This file is part of Unifix BWidget Toolkit
# Definition of resources
# ------------------------------------------------------------------------------


# --- symbolic names of buttons ------------------------------------------------

option add *abortName [::msgcat::mc {&Abort}]
option add *retryName [::msgcat::mc {&Retry}]
option add *ignoreName [::msgcat::mc {&Ignore}]
option add *okName [::msgcat::mc {&OK}]
option add *cancelName [::msgcat::mc {&Cancel}]
option add *yesName [::msgcat::mc {&Yes}]
option add *noName [::msgcat::mc {&No}]


# --- symbolic names of label of SelectFont dialog ----------------------------

option add *boldName [::msgcat::mc {Bold}]
option add *italicName [::msgcat::mc {Italic}]
option add *underlineName [::msgcat::mc {Underline}]
option add *overstrikeName [::msgcat::mc {Overstrike}]
option add *fontName [::msgcat::mc {&Font}]
option add *sizeName [::msgcat::mc {&Size}]
option add *styleName [::msgcat::mc {St&yle}]
option add *colorPickerName [::msgcat::mc {&Color...}]


# --- symbolic names of label of PasswdDlg dialog -----------------------------

option add *loginName [::msgcat::mc {&Login}]
option add *passwordName [::msgcat::mc {&Password}]


# --- resource for SelectFont dialog ------------------------------------------

option add *SelectFont.title [::msgcat::mc {Font selection}]
option add *SelectFont.sampletext [::msgcat::mc {Sample text}]


# --- resource for MessageDlg dialog ------------------------------------------

option add *MessageDlg.noneTitle [::msgcat::mc {Message}]
option add *MessageDlg.infoTitle [::msgcat::mc {Information}]
option add *MessageDlg.questionTitle [::msgcat::mc {Question}]
option add *MessageDlg.warningTitle [::msgcat::mc {Warning}]
option add *MessageDlg.errorTitle [::msgcat::mc {Error}]

# --- resource for PasswdDlg dialog -------------------------------------------

option add *PasswdDlg.title [::msgcat::mc {Enter login and password}]

# --- symbolic names of label of SelectColor dialog ----------------------------

option add *baseColorsName [::msgcat::mc {Base colors}]
option add *userColorsName [::msgcat::mc {User colors}]

option add *yourSelectionName [::msgcat::mc {Your Selection}]
option add *colorSelectorsName [::msgcat::mc {Color Selectors}]

# --- dynamic help text for SelectColor dialog. Lines 75 chars max, split by '\n'.

option add *mouseHelpTextName [::msgcat::mc {Click or drag the mouse in the Color Selectors to choose a color.\nIf the selected color remains black, regardless of what you\ndo in the left-hand Color Selector (for hue and saturation), check\nthe position of the pointer in the right-hand Color Selector\n(for brightness).\n\nClick one of the "Base colors" to read a value from this palette.\n\nClick one of the "User colors" to read a value from this palette,\nor to write to the palette if the color is blank. If you then\nuse the Color Selectors to change the color, your choice will be\nwritten to this (User) palette color until you select another\n(Base or User) palette color.}]

option add *keyboardHelpTextName [::msgcat::mc {Click in the text entry window in the left of the "Your\nSelection" area.\n\nType the color that you want in hexadecimal RGB format.\nWhenever the number of hexadecimal digits is a multiple\nof 3, the color value is valid and will be copied to the\nother parts of the Color Selector.\n\nLeave the text entry window by clicking anywhere else,\nor by pressing the "Escape" or "Return" key. The text\nentry window will then display the color in 24-bit RGB\nformat, although internally the Color Selector uses\n48-bit colors.\n\nWhen the text entry widget does not have keyboard focus\n(i.e. does not show a cursor), the "Return" and "Escape"\nkeys do the same as the "OK" and "Cancel" buttons,\nrespectively.}]
