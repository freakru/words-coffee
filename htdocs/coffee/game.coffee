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
        $('#answer').unbind().keyup (e) =>
            @handleEvents(e)

        $('#enter').unbind().click ->
            press = jQuery.Event("keyup")
            press.ctrlKey = false
            press.which = 13
            press.keyCode = 13
            $("#answer").trigger(press)

        $('.box').on 'click', '.letter', ->
            $letterElement = $(this)
            letter = $letterElement.text().firstChar()
            partWord = $("#answer").val()
            word = partWord + letter

            if $letterElement.hasClass('selected')
                $letterElement.removeClass('selected')
                word = $("#answer").val().replace(letter, '')
            else
                $letterElement.addClass('selected')
            
            $("#answer").val(word)
            $("#answer").focus()

            press = jQuery.Event("keyup")

        $('#showMenu').unbind().click ->
            $('#menu').toggle()
            return false

        $('#new').unbind().click =>
            @reset()
            $('#menu').hide()

        $('#scores').unbind().click =>
            @request.get {r: 'user/get-scores'}, (data) =>
                @showScores(data)
                $('#menu').hide()
                e.preventDefault()
        
         $('#save').unbind().click =>
            @save()
            $('#menu').hide()

         $('#load').unbind().click =>
            @load()
            $('#menu').hide()

        $('#achiev').unbind().click =>
            @showAchievements()
            $('#menu').hide()
            e.preventDefault()

        $('.input-clear').on 'click', (e) ->
            $(this).prev('input').val("").focus()
            $('.letter').removeClass('selected')
            e.preventDefault()

        $('.close').on 'click', (e) ->
            $(this).parent().hide()
            e.preventDefault()

        $('body').on 'click', '.add-word', (e) ->
            @addWord($('.add-word-container strong').text())
            e.preventDefault()

        $('.add-word-close').on 'click', (e) ->
            $('#message').fadeOut()
            e.preventDefault()

        $('#sort-a').toggle(
            => 
                @correctAnswers.sortA().reverse()
                @populateAnswers()
            =>
                @correctAnswers.sortA()
                @populateAnswers()
        )

        $('#sort-l').toggle(
            => 
                @correctAnswers.sortL().reverse()
                @populateAnswers()
            =>
                @correctAnswers.sortL()
                @populateAnswers()
        )

        $('#sort-s').toggle(
            => 
                @correctAnswers.sortS().reverse()
                @populateAnswers()
            =>
                @correctAnswers.sortS()
                @populateAnswers()
        )

        $('.lang[id="lang-#{@lang}"]').addClass 'selected'

        $('.lang').unbind().click (e) =>
            $('.lang').removeClass('selected')
            $(this).addClass('selected')
            @lang = $(this).attr('data-lang')
            @play()
            e.preventDefault()

        $('#username-enter').unbind().click =>            
            @enterUsername()

        $('#username').unbind().keyup (e) ->
            $("#username-enter").click() if e.keyCode == 13


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
        for letter of @lettersWeights
            rawWeight = @lettersWeights[letter]
            if rawWeight > maxPercent
                maxPercent = rawWeight        
        
        for letter of @lettersWeights
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
        mainLetters = @mainword.split('')
        answerLetters = answer.split('')
        answerLettersLen = answerLetters.length
        score = @getScore(answer)

        return @error(t.min_word_length.format(minWordLen)) if answer.length < minWordLen
        return @error(t.already_used.format(answer.strong())) if answer is @mainword
        return @error(t.min_score.format(minScore)) if score < minScore
        return @error(t.already_used.format(answer.strong())) if @correctAnswers.containsWord(answer)

        availableLetters = @mainword.split ''
        for letter in answerLetters
            return @error(t.cannot_make.format(answer.strong(), @mainword.strong())) unless availableLetters.contains(letter)

            idx = availableLetters.indexOf(letter)
            return @error(t.cannot_make.format(answer.strong(), @mainword.strong())) if idx is -1

            availableLetters.splice(idx, 1)
        return true


    @ask = (word) ->
       return false if !@isCorrectWord(word)
       @request.get {r: 'dictionary/try', word: word}, (data) =>
        if data.isAllowed
            return @tryAnswer data.word
        else
            @errorAddWord(t.unknown_word.format(word.strong()))

    @tryAnswer = (word) ->
        return false unless @isCorrectWord word

        score = @getScore(word)
        countLetters = word.length
        $answerRow = $('<tr><td>' + word + '</td><td>' + countLetters + '</td><td>' + score + '</td></tr>')
        $('#answerContainer table').prepend($answerRow)

        @addScore(score)
        @graphic.updateLevelBar @level, @score, @maxLevel, @nextLevel
        @updateLevel()

        @used.palindrome++ if @isPalindrome word
        @used.anagram++ if @isAnagram word
        @used.shortWords++ if word.length < 4
        used.longWords++ if word.length > 6
        @used.rareLetters++ if word.containsRare()
        @used.expensiveWords++ if @isExpensive word

        @correctAnswers.push w:word, s:score

        @updateWords()      
        @checkAchievements word      
        @save()
      
        $('.letter').removeClass('selected')
        $('#answerLetters').empty()
        $('#answer').val('')
        $('#answer').focus()
        return


    @getScore = (word) ->
        score = 0
        letters = word.split('')
        lettersLen = letters.length
        for letter in letters
            score += @getLetterWeight letter
    
        return score

    @addScore = (score) ->
        @score = parseInt(@score + score, 10)
        $('#score').text(t.score + ': ' + @score)
    
        @request.get {r: 'user/set-score', score: @score}, (data) =>
            @isFirst = data? && data.isFirst
            return

    @updateLevel = () ->
        return false if @level >= @maxLevel
        $('#level').text(t.level + ': ' + @level)

    @updateWords = () ->
        $('#words').text t.words + ': ' + @correctAnswers.length
  
    @nextLevel = () ->
        return false if @level >= @maxLevel
        @level++
        @getMainword()
        @draw()        

    @populateTimer = () ->
        $('#timer').text t.time + ': ' + @timer.formatTime()

    @setTimer = () ->
        populateTimer()
        @timer++
        
        setTimeout(=>
            @setTimer()
        1000)
        @checkAchievements type: 'time'
        return

    @checkAchievements = (arg) ->
        type = ''
        word = ''
        if typeof(arg) == 'object'
            type = arg.type
        else
            word = arg

        for achievement in achievements
            achievement.fn
            regExp = new RegExp type

            continue if type && !regExp.test achievement.n
            continue if typeof fn != 'function'

            if !achievement.isCompleted && fn.apply(this, [word, achievement.p])
        
                header = achievement.header + ' +' + achievement.s
                @graphic.message header, achievement.description, 'achievement'
                
                achievement.isCompleted = true
                achievement.date = new Date()
                @graphic.updateLevelBar this.level, this.score, this.maxLevel, this.nextLevel
                @updateLevel()
                @updateWords()
                log('achiev ' + score)
                @achievScore += achievement.s
        return


    @drawEmpty = () ->
        # TODO

    @draw = () ->
        mainLetters = @mainword.split('')
        $mainContainer = $('.box')
        $mainContainer.empty()
        
        for letter in mainLetters
            weight = @getLetterWeight(letter)
          
            $weight = $('<div>')
            .attr('class', 'weight w' + weight)
            .text(weight)
            
            $('<div>').attr({
                'class': 'letter' 
            })
            .text(letter)
            .append($weight)
            .appendTo($mainContainer)
        $mainContainer.append('<div class="clear" />')

    @handleEvents = (e) ->
        switch e.keyCode
            # Enter
            when 13
                return false if !$('#answer').val()
                graphic.animateAnswer()
                @ask($('#answer').val())
                e.preventDefault()
            # Esc
            when 27
                $('#answerLetters').empty()
                $('#answer').val('')
                $('.letter').removeClass('selected')
                e.preventDefault()
            # Backspace
            when 8
                @animateLetters()
                e.preventDefault()
            else
                @animateLetters()

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