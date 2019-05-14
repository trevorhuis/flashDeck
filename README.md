# MobileComputingFinal
Final Project for our Mobile Computing Project

Instructions: 
Welcome to FlashDeck! 
This app serves users by allowing them to create custom decks of flashcards and study them.


TABLEVIEW
The Initial View has a Table View, and a UI Button.

-Core Data will load in a single deck titled "Presidents", click on this cell, or any cell to view its contents.
-Hit the UIbutton to add a new deck to the stack 
-Swipe on a table view cell to delete the corresponding deck.
**Note: if there are no decks stored in core data on app launch then the presidents deck will be loaded from the Plist**


COLLECTIONVIEW
The Deck View has a Collection View, Three UI Buttons, and a Label with a double tap gesture recognizer.

-Deck view will populate its collection view with "cards" that have been saved into the correspond deck, if there are no cards saved, the collection view will be empty. 
-Hit the + UI Button to add a new card to the deck
-Click on a cell in the collection view to edit it
-Double tap the label at the top of the screen to edit the name of the deck
-Tap the study reminders button to set study reminders
-Tap the learn button to enter the learning mode, if no cards have been added to deck button will prompt user to add cards
-Swipe to navigate back to table view

**EXTRA CREDIT: If a deck is opened for the first time, a semi-transparent tutorial view will appear on this screen**


ADD/EDIT CARD VIEW
The Add/ Edit Card View has a Text Field, Two UI Buttons, and Swipe gesture recognizers

If adding new card: 
    -tap text field to edit text, user must edit field and hit done to allow further action
    -swipe gestures navigate from back and front of card
    -delete button prompts user if they're sure they wish to delete, then navigates to collection view screen
    -done button verifies front and back of card have saved text, if not code prompts user to add to both sides, else saves card to core data, then navigates to collection view
    
if editing/deleting existing card:
    -swipe gestures navigate from back and front of card
    -tap text field to edit text, if edits are made, user must hit done before further action
    -delete button prompts user if they're sure they wish to delete card, then navigates to collection view screen
    -done button checks if card has changed from what is saved in core data, if not, return to collection view. else, update core date then return to collection view
    
**EXTRA CREDIT: If add/edit view is opened for the first time, a semi-transparent tutorial view will appear on this screen**


CALENDAR VIEW
The Calendar View has a UI Button, and a Calendar Scroll Wheel

-UI Button will prompt user if they wish to allow for calendar access
-if so, button will set a 15 minute block on the calendar titled the name of the app "study session"


LEARN VIEW
The learn view has a UI Image, Label, and gesture recognizers

-Image view will populate with a random card in the deck and randomly display the front, or back of that card
-User can swipe right or left to flip the card and view the other side
-Swipe up gesture indicates user guessed  the card's backside correctly, displays next card
-Swipe down gesture indicated user incorrectly guessed the card's backside, displays next card and puts card back in que

**EXTRA CREDIT: If learn view is opened for the first time, a semi-transparent tutorial view will appear on this screen**
**EXTRA CREDIT: Unique card flipping animation, and swipe up/ down animations create a smooth user experience**

Developed with Khalid Alkhatib, Tyson Smiter, and Luis Carlos Orozco
