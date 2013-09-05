window.Game = (lang) ->
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
            callback()

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
        graphic.updateLevelBar @level, @score, @maxLevel, @nextLevel
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
        
        return this.lettersWeights[letter]

    @illLettersWeights = () ->
        # clone  
        this.lettersWeights = $.extend true, {}, letterFrequency[this.lang]
        
        maxPercent = 0
        for letter in this.lettersWeights
            rawWeight = this.lettersWeights[letter]
            if rawWeight > maxPercent
                maxPercent = rawWeight        
        
        for letter in this.lettersWeights
          rawWeight = this.lettersWeights[letter]
          weight = rawWeight / maxPercent
          this.lettersWeights[letter] = maxLetterWeight - Math.ceil(maxLetterWeight * weight) + 1

    @populateUser = () ->
        $('#user').text "#{t.hallo} #{@userName}"
  
  
    @isPalindrome = (word) ->
        word.length > 4 && @orrectAnswers.containsWord word.reverse()

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
        $('#words').text t.words + ': ' + this.correctAnswers.length
  
    @nextLevel = () ->
        #TODO

    @populateTimer = () ->
        $('#timer').text t.time + ': ' + this.timer.formatTime()

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
        #TODO

    @completeLoad = () ->
        #TODO

    @reset = () ->
        localStorage.setItem 'wordGame', null
        window.request.get {r: 'user/reset'}, () ->
            window.location.reload()

    @enterUsername = () ->
        username = $('#username').val()
        return false if !username

        window.request.get {r: 'user/enter-username', username: username}, (data) =>
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
        #TODO
    return