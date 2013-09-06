window.Game = (lang, graphic, request) ->
    @graphic = graphic
    @request = request

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
        strGameState = localStorage.getItem('wordGame')
        strGameState == null || strGameState == "" || strGameState == 'null'

    @play = () ->
        if @isNewGame()
          @getLanguage('completeSetup')
        else
          @load()

    @getLanguage = (callback) ->
        $.getScript "js/game.language.#{@lang}.js", () =>
            @[callback]?()

    @completeSetup = () ->
        log 'play begins'
    
        if @isNewGame()
            $('#modal').modal {keyboard: false}
        else
            @populateUser()
        
        
        @localize()
        @initControls()
        @drawEmpty()
        @populateTimer()
        @addScore 0
        @graphic.updateLevelBar @level, @score, @maxLevel, @nextLevel
        @updateLevel()

    @localize = () ->
        $('[data-t]').each () ->
            key = $(this).attr 'data-t'
            $(this).text t[key]


        $('#showMenu').attr('title', t.menu)
        $('#new').text(t.snew)
        $('#scores').text(t.scores) 
        $('#save').text(t.save)
        $('#load').text(t.load)
        $('#username-label').text(t.username)
        $('#achiev').text(t.achievements)

    @initControls = () ->
        # TODO: implement

    @initAchievements = () ->
        @maxAchievScore = 0
        # TODO: implement

    @initRareLetters = () ->
        @rareLetters = []
        @rareLetters.push letter for letter in @lettersWeights when @lettersWeights[letter] == maxLetterWeight
        
    @getMainword = () ->
        mainWordsArr = mainwords[@lang].split(',')
        
        mainWordsLen = mainWordsArr.length
        idx = Math.floor(Math.random() * mainWordsLen)
        @mainword = mainWordsArr[idx]

    @getLetterWeight = (letter) ->
        if @lettersWeights == null
          @fillLettersWeights()
        
        return @lettersWeights[letter]

    @fillLettersWeights = () ->
        # clone  
        @lettersWeights = $.extend true, {}, letterFrequency[@lang]
        
        maxPercent = 0
        for letter in @lettersWeights
            rawWeight = @lettersWeights[letter]
            if rawWeight > maxPercent
                maxPercent = rawWeight        
        
        for letter in @lettersWeights
          rawWeight = @lettersWeights[letter]
          weight = rawWeight / maxPercent
          @lettersWeights[letter] = maxLetterWeight - Math.ceil(maxLetterWeight * weight) + 1

    @populateUser = () ->
        $('#user').text "#{t.hallo} #{@userName}"
  
  
    @isPalindrome = (word) ->
        word.length > 4 && @correctAnswers.containsWord word.reverse()

    @isAnagram = (word) ->
        # TODO: implement

    @isExpensive = (word) ->
        50 <= @getScore word

    @isCorrectWord = (answer) ->
        # TODO: implement

    @ask = (word) ->
        # TODO: implement

    @tryAnswer = (word) ->
        #TODO: implement

    @getScore = (word) ->
        # TODO: implement

    @addScore = (score) ->
        # TODO: implement

    @updateLevel = () ->
        # TODO

    @updateWords = () ->
        $('#words').text t.words + ': ' + @correctAnswers.length
  
    @nextLevel = () ->
        #TODO

    @populateTimer = () ->
        $('#timer').text t.time + ': ' + @timer.formatTime()

    @setTimer = () ->
        # TODO

    @checkAchievements = (arg) ->
        # TODO

    @drawEmpty = () ->
        # TODO

    @draw = () ->
        # TODO

    @handleEvents = (e) ->
        # TODO

    @animateLetters = () ->
        # TODO

    @error = (message) ->
        # TODO

    @errorAddWord = (message) ->
        # TODO

    @addWord = (word) ->
        # TODO

    @showAchievements = () -> 
        # TODO

    @showScores = (scores) ->
        #TODO

    @save = () ->
        # TODO

    @load = () ->
        strGameState = localStorage.getItem 'wordGame'
        gameState = JSON.parse strGameState, (key, value) ->            
            value = value?.fromIsoDate() if key is 'date'            
            return value
        
        @timer = gameState.timer
        @level = gameState.level
        @score = gameState.score
        @correctAnswers = gameState.correctAnswers
        @achievScore = gameState.achievScore
        @achievements = gameState.achievements
        @used = gameState.used
        @userId = gameState.userId
        @userName = gameState.userName
        @lang = gameState.lang
        
        @getLanguage('completeLoad')

    @completeLoad = () ->
        @localize()
    
        @fillLettersWeights()
        @initRareLetters()
        @initAchievements()
        @populateAnswers()
        @populateUser()
        
        @addScore(0)
        @graphic.updateLevelBar(@level, @score, @maxLevel, @nextLevel)
        @updateLevel()
        @updateWords()
        @initControls()
        
        @getMainword()
        @draw()
        @populateTimer()
        @updateWords()
        @setTimer()

    @reset = () =>
        localStorage.setItem 'wordGame', null
        @request.get {r: 'user/reset'}, () ->
            window.location.reload()

    @enterUsername = () =>
        username = $('#username').val()
        return false if !username

        @request.get {r: 'user/enter-username', username: username}, (data) =>
            if data.success
                  @userId = data.userId
                  @userName = data.userName
                  @getMainword()
                  @fillLettersWeights()
                  @initAchievements()
                  @initRareLetters()

                  @draw()
                  @populateUser()
                  @save()
                  $('#modal').modal('hide')
                  @setTimer()
                  return

    @populateAnswers = () ->
        $('#answerContainer table tbody').empty()

        for answer in @correctAnswers
            $answerRow = "
            <tr><td>#{answer.w}</td>
            <td>#{answer.w.length}</td><td>#{answer.s}</td></tr>"
            $('#answerContainer table tbody').prepend $answerRow

    return