Game = (lang) ->
    @mainword = ''
    @timer = 0
    @score = 0
    @lettersWeights = null
    @correctAnswers = []
  
    @level = 1
    @achievScore = 0
    @maxAchievScore = 0

    @rareLetters = []
    @maxLevel = 50
  
    @userId = 0
    @userName = ''
    @isFirst = false   
  
    @lang = lang

    @used =
        rareLetters: 0,
        shortWords: 0,
        longWords: 0,
        palindrome: 0,
        anagram: 0,
        expensiveWords: 0

    @isNewGame = () ->
        strGameState = localStorage.getItem('wordGame');
        strGameState == null || strGameState == "" || strGameState == 'null'

    @play = () ->
        if @isNewGame()
          @getLanguage('completeSetup')
        else
          @load()

    @getLanguage = (callback) ->
        $.getScript "js/game.language.#{@lang}.js", () =>
          @callback()