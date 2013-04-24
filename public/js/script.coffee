saveNewData = (newData) ->
    req = $.ajax
        url:'/home/' + newData
        type:'post'
        success: (e) ->
            console.log e.project_title
            $('p').empty().html e.project_title

btnClickEvent = ->
    $('body').on 'click', 'button', ->
        saveNewData $('textarea').val()

btnClickEvent()

$('textarea,button').hide()

changeTxtNode = ->
    $('body').on 'click' ,'p', ->
        $('textarea,button').show()
        $text = $('p').text()
        $('textarea').append($text)
changeTxtNode()


