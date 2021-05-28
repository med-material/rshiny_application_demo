
## Modules for importing data to the application

## Modules for modifying data

## Modules for displaying output

## Modules inside Modules
 When calling a module inside a module it is important to remember:
 In your UI function, you must encapsulate the ID itself with ns()
 In your callModule function, you should NOT encapsulate the ID.

An easy mistake is to encapsulate the ID with ns() in both places, but that will not work.