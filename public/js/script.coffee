saveNewData = (newData) ->
    req = $.ajax
        url:'/home/' + newData
        type:'post'
        success: (e) ->
            console.log e.project_title
            $('h1').empty().html e.project_title

saveFormData = ->
    $('body').on 'click', 'button', ->
        saveNewData $('input').val()

saveFormData()

$('input,button').hide()

changeTxtNode = ->
    $('body').on 'click' ,'h1', ->
        $('input,button').show()
changeTxtNode()


