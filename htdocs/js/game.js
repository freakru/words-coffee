// Generated by CoffeeScript 1.6.3
(function() {
  window.Game = function(lang) {
    this.mainword = '';
    this.timer = 0;
    this.score = 0;
    this.lettersWeights = null;
    this.correctAnswers = [];
    this.level = 1;
    this.achievScore = 0;
    this.maxAchievScore = 0;
    this.rareLetters = [];
    this.maxLevel = 50;
    this.userId = 0;
    this.userName = '';
    this.isFirst = false;
    this.lang = lang;
    this.used = {
      rareLetters: 0,
      shortWords: 0,
      longWords: 0,
      palindrome: 0,
      anagram: 0,
      expensiveWords: 0
    };
    this.isNewGame = function() {
      var strGameState;
      strGameState = localStorage.getItem('wordGame');
      return strGameState === null || strGameState === "" || strGameState === 'null';
    };
    this.play = function() {
      if (this.isNewGame()) {
        return this.getLanguage('completeSetup');
      } else {
        return this.load();
      }
    };
    this.getLanguage = function(callback) {
      var _this = this;
      return $.getScript("js/game.language." + this.lang + ".js", function() {
        return _this.callback();
      });
    };
    this.completeSetup = function() {
      log('play begins');
      if (this.isNewGame()) {
        $('#modal').modal({
          keyboard: false
        });
      } else {
        this.populateUser();
      }
      this.localize();
      this.initControls();
      this.drawEmpty();
      this.populateTimer();
      this.addScore(0);
      graphic.updateLevelBar(this.level, this.score, this.maxLevel, this.nextLevel);
      return this.updateLevel();
    };
    this.localize = function() {
      $('[data-t]').each(function() {
        var key;
        key = $(this).attr('data-t');
        return $(this).text(t[key]);
      });
      $('#showMenu').attr('title', t.menu);
      $('#new').text(t.snew);
      $('#scores').text(t.scores);
      $('#save').text(t.save);
      $('#load').text(t.load);
      $('#username-label').text(t.username);
      return $('#achiev').text(t.achievements);
    };
    this.initControls = function() {};
    this.initAchievements = function() {
      return this.maxAchievScore = 0;
    };
    this.initRareLetters = function() {
      var letter, _i, _len, _ref, _results;
      this.rareLetters = [];
      _ref = this.lettersWeights;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        letter = _ref[_i];
        if (this.lettersWeights[letter] === maxLetterWeight) {
          _results.push(this.rareLetters.push(letter));
        }
      }
      return _results;
    };
    this.getMainword = function() {
      var idx, mainWordsArr, mainWordsLen;
      mainWordsArr = mainwords[this.lang].split(',');
      mainWordsLen = mainWordsArr.length;
      idx = Math.floor(Math.random() * mainWordsLen);
      return this.mainword = mainWordsArr[idx];
    };
    this.getLetterWeight = function(letter) {
      if (this.lettersWeights === null) {
        this.fillLettersWeights();
      }
      return this.lettersWeights[letter];
    };
    this.illLettersWeights = function() {
      var letter, maxPercent, rawWeight, weight, _i, _j, _len, _len1, _ref, _ref1, _results;
      this.lettersWeights = $.extend(true, {}, letterFrequency[this.lang]);
      maxPercent = 0;
      _ref = this.lettersWeights;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        letter = _ref[_i];
        rawWeight = this.lettersWeights[letter];
        if (rawWeight > maxPercent) {
          maxPercent = rawWeight;
        }
      }
      _ref1 = this.lettersWeights;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        letter = _ref1[_j];
        rawWeight = this.lettersWeights[letter];
        weight = rawWeight / maxPercent;
        _results.push(this.lettersWeights[letter] = maxLetterWeight - Math.ceil(maxLetterWeight * weight) + 1);
      }
      return _results;
    };
    this.populateUser = function() {
      return $('#user').text("" + t.hallo + " " + this.userName);
    };
    this.isPalindrome = function(word) {
      return word.length > 4 && this.orrectAnswers.containsWord(word.reverse());
    };
    this.isAnagram = function(word) {};
    this.isExpensive = function(word) {
      return 50 <= this.getScore(word);
    };
    this.isCorrectWord = function(answer) {};
    this.ask = function(word) {};
    this.tryAnswer = function(word) {};
    this.getScore = function(word) {};
    this.addScore = function(score) {};
    this.updateLevel = function() {};
    this.updateWords = function() {
      return $('#words').text(t.words + ': ' + this.correctAnswers.length);
    };
    this.nextLevel = function() {};
    this.populateTimer = function() {
      return $('#timer').text(t.time + ': ' + this.timer.formatTime());
    };
    this.setTimer = function() {};
    this.checkAchievements = function(arg) {};
    this.drawEmpty = function() {};
    this.draw = function() {};
    this.handleEvents = function(e) {};
    this.animateLetters = function() {};
    this.error = function(message) {};
    this.errorAddWord = function(message) {};
    this.addWord = function(word) {};
    this.showAchievements = function() {};
    this.showScores = function(scores) {};
    this.save = function() {};
    this.load = function() {};
    this.completeLoad = function() {};
    this.reset = function() {
      localStorage.setItem('wordGame', null);
      return window.request.get({
        r: 'user/reset'
      }, function() {
        return window.location.reload();
      });
    };
    this.enterUsername = function() {
      var username,
        _this = this;
      username = $('#username').val();
      if (!username) {
        return false;
      }
      return window.request.get({
        r: 'user/enter-username',
        username: username
      }, function(data) {
        if (data.success) {
          _this.userId = data.userId;
          _this.userName = data.userName;
          _this.getMainword();
          _this.fillLettersWeights();
          _this.initAchievements();
          _this.initRareLetters();
          _this.draw();
          _this.populateUser();
          _this.save();
          $('#modal').modal('hide');
          _this.setTimer();
        }
      });
    };
    this.populateAnswers = function() {};
  };

}).call(this);
