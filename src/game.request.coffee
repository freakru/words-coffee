Request = () ->
    @get = (data, successCallback) ->
        $.ajax {
            url: 'protected/ajax.php',
            type: 'post',
            data: data,
            dataType: 'json',
            success: (data) ->
              successCallback?(this, data)
            ,
            error: (e, type, message) ->
                console.error message
                graphic.message 'Error', message
            }