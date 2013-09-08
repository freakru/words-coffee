window.Graphic = () ->
    @getWindow = ($window, header, content) ->
        $('.modal-header h3', $window).html(header)
        $('.win-content', $window)
          .empty()
          .append(content)
          .show()
        $window.modal({keyboard: false})

    @message = (header, description, theme, duration) ->
        life = 3000
        life = duration?
        
        $.jGrowl description,
          header: header,
          theme: theme,
          life: life

    @animateAnswer = () ->
        oldBackground = $('#answer').css('background-color')
        newBackground = '#fff'
        $('#answer').css('background-color', newBackground)
        callback = ->
            $('#answer').css('background-color', oldBackground)
        setTimeout callback, 200

    @updateLevelBar = (level, score, maxLevel, nextLevelCallback) ->
        if level >= maxLevel
            return false
           
        $levelBar = $('#level-bar .level-chunk')
        maxLevelBarLen = $('#level-bar').width()
        scorePerLevel = 120
        scoreMuliplicator = maxLevelBarLen / scorePerLevel
        levelBarLen = score * scoreMuliplicator % maxLevelBarLen
        
        if score > scorePerLevel * level
            if nextLevelCallback?
                nextLevelCallback()
                $levelBar.addClass('notransition')
    return