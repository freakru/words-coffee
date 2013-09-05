$ ->
    $('.draggable').draggable()
    maxLetterWeight = 10
    minWordLen = 2
    minScore = 5
    debug = true

    game = new Game(navigator.language);
    graphic = new Graphic();
    request = new Request();

    game.play()
    $('#answer').focus()
    console.log game
    return
