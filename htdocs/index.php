<?php header('Content-Type: text/html; charset=utf-8') ?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <script data-main="js/main" src="js/lib/require.min.js"></script>
    
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" type="text/css"/>
    <link rel="stylesheet" href="css/jquery.jgrowl.css" type="text/css"/>
    <link rel="stylesheet" href="css/main.css" type="text/css" />
  </head>
  <body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
                <ul class="dropdown-menu">
                  <li><a id ="new" href="#">New</a></li>
                  <li><a id="achiev" href="#">Achievements</a></li>
                  <li><a id="scores" href="#">Scores</a></li>
                  <li class="divider"></li>
                  <li class="nav-header">Nav header</li>
                  <li><a href="#">Separated link</a></li>
                  <li><a href="#">One more separated link</a></li>
                </ul>
              </li>
              <li><a id="level"></a></li>
              <li><a id="timer"></a></li>
              <li><a id="score"></a></li>
              <li><a id="words"></a></li>
            </ul>
            <form class="navbar-form pull-right">
              <input class="span2" type="text" placeholder="Email">
              <input class="span2" type="password" placeholder="Password">
              <button type="submit" class="btn">Sign in</button>
            </form>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container">

      <div id="gameContainer">

        <div id="bar">

        </div>
        <div id="level-bar" class="progress">
          <div class="level-chunk bar"></div>
        </div>

        <div class="box">

        </div>

        <div class="form">
          <div class="input-append">
            <input id="answer" class="input-xlarge"type="text">
            <i class="input-clear icon-remove"></i>
            <button id="enter" class="btn" type="button">Enter</button>
          </div>
        </div>

        <div id="answerContainer">
          <table class="table table-striped">
            <thead>
              <tr>
                <th>
                  <a id="sort-a"></a>
                </th>
                <th>
                  <a id="sort-l"></a>
                </th>
                <th>
                  <a id="sort-s"></a>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
        <div id="status"></div>

      </div><!-- hero-unit -->

    </div><!-- container -->

    <div id="modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 data-t="hallo"></h3>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <div class="control-group">
            <label id="username-label" class="control-label" for="username">Email</label>
            <div class="controls">
              <input type="text" id="username" placeholder="">
            </div>
          </div>
          <div class="control-group">
            <div class="controls">
              <a href="#" id="lang-en" data-lang="en" class="lang"></a>
              <a href="#" id="lang-de" data-lang="de" class="lang"></a>
              <a href="#" id="lang-ru" data-lang="ru" class="lang"></a>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button id="username-enter" data-t="save" class="btn btn-primary"></button>
      </div>
    </div>

    <div id="win-achievements" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3></h3>
      </div>
      <div class="modal-body">
        <div class="win-content"></div>
      </div>
      <div class="modal-footer">

      </div>
    </div>
    
    <div id="win-scores" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3></h3>
      </div>
      <div class="modal-body">
        <div class="win-content"></div>
      </div>
      <div class="modal-footer">

      </div>
    </div>

  </body>
</html>