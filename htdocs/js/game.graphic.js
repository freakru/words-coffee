// Generated by CoffeeScript 1.6.3
(function() {
  window.Graphic = function() {
    this.getWindow = function($window, header, content) {
      $('.modal-header h3', $window).html(header);
      $('.win-content', $window).empty().append(content).show();
      return $window.modal({
        keyboard: false
      });
    };
    this.message = function(header, description, theme, duration) {
      var life;
      life = 3000;
      life = duration != null;
      return $.jGrowl(description, {
        header: header,
        theme: theme,
        life: life
      });
    };
    this.animateAnswer = function() {
      var callback, newBackground, oldBackground;
      oldBackground = $('#answer').css('background-color');
      newBackground = '#fff';
      $('#answer').css('background-color', newBackground);
      callback = function() {
        return $('#answer').css('background-color', oldBackground);
      };
      return setTimeout(callback, 200);
    };
    this.updateLevelBar = function(level, score, maxLevel, nextLevelCallback) {
      var $levelBar, animate, levelBarLen, maxLevelBarLen, scoreMuliplicator, scorePerLevel, t;
      if (level >= maxLevel) {
        return false;
      }
      $levelBar = $('#level-bar .level-chunk');
      maxLevelBarLen = $('#level-bar').width();
      scorePerLevel = 120;
      scoreMuliplicator = maxLevelBarLen / scorePerLevel;
      levelBarLen = score * scoreMuliplicator % maxLevelBarLen;
      if (score > scorePerLevel * level) {
        if (nextLevelCallback != null) {
          nextLevelCallback();
          $levelBar.addClass('notransition');
        }
      }
      $levelBar.css({
        width: levelBarLen + 'px'
      });
      animate = function() {
        return $levelBar.removeClass('notransition');
      };
      return t = setTimeout(animate, 700);
    };
  };

}).call(this);
