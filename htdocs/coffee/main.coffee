require ["lib/jquery-2.0.2.min", "lib/jquery-ui.min", "lib/jquery.jgrowl.min",
"bootstrap/js/bootstrap.js",
"game.functions",]

require ["lib/coffee-script"], (CoffeeScript) ->
    $ ->
        loadCoffee = (files) -> 
            $head = $ "head"
            load = (file) ->
                coffeeFile = "coffee/#{file}.coffee"
                $.get coffeeFile, (content) ->
                    compiled = CoffeeScript.compile content, {bare: on}
                    $("<script />").attr("type", "text/javascript").html(compiled).appendTo $head
            load file for file in files
        loadCoffee ['game', 'game.request', 'game.graphic', 'game.ready']
        return

#require ["game.achievements", "game.graphic", "game.ready"]