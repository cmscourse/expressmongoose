dbFetch = ->
  $.ajax
    url:'/'
    success: (data) ->
      console.log data.length
      $(data).each ->
        console.log this.project_title
        $('body').append('<li>' + this.project_title + '</li>')
#dbFetch()

fetchMusicFolders = ->
  url = '/getMusicFolders'
  $.ajax
      url:url
      success: (dat) ->
          console.log $.parseJSON(dat)
          obj = $.parseJSON(dat)
          musicFolderId = $('#music-folder').text()
          url = '/getIndexes/' + musicFolderId
          console.log 'ajax success'
          console.log obj['subsonic-response']['musicFolders']['musicFolder']
          $(obj['subsonic-response']['musicFolders']['musicFolder']).each ->
            console.log 'each'
            $('#album').append '<li><a class=foldername href=/allMusic/' + this.id + ' >' + this.name + '</a></li>'
          $.ajax
            url:url
            success: (dat) ->
              jsonData = $.parseJSON(dat)
              console.log jsonData['subsonic-response']['indexes']['index']
              $(jsonData['subsonic-response']['indexes']['index']).each ->
                console.log this.artist if this.artist.name == undefined
                console.log this.artist.length if this.artist.name == undefined
                $(this.artist).each ->
                  $('body').append '<li><em><a href=/singleView/' + this.id + ' >' + this.name + '</a></em></li>'
                $('body').append '<li><a href=/singleView/' + this.artist.id + ' >' + this.artist.name + '</a></li>' if this.artist.name != undefined

            ###
            $.ajax
              url: url
              success: (dat) ->
                dat = $.parseJSON(dat)
                #$(dat['subsonic-response']['indexes']).each ->
                console.log dat['subsonic-response']
                $(dat['subsonic-response']['indexes']['index']).each ->
                  console.log 'loop1'
                  console.log this.artist.name

                  $('body').append this.artist.name
                  $(this.artist).each ->
                    console.log 'loop2'
                    $('body').append '<li>' + this.name + '</li>'
                    console.log this.name
                ###


fetchMusicFolders()

$ ->
  $('body').on 'click', '.foldername', (e) ->
    #e.preventDefault()
    console.log 'foo'



