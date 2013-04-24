
hideForm = ->
  $('textarea,button').hide()
hideForm()

saveNewData = (newData) ->
    req = $.ajax
        url:'/home/' + newData
        type:'post'
        success: (e) ->
            $('p').empty().html e.project_title
            hideForm()

btnClickEvent = ->
    $('body').on 'click', 'button', ->
        saveNewData $('textarea').val()

btnClickEvent()


changeTxtNode = ->
    $('body').on 'click' ,'p', ->
        $('textarea,button').show()
        $text = $('p').text()
        $('textarea').append($text)
changeTxtNode()


