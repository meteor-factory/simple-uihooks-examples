@Games = new Mongo.Collection('games')

if Meteor.isClient

  Template.games.helpers
    games: () ->
      Games.find()

  Template.games.rendered = ->
    @$('.animated')[0]._uihooks = {
      insertElement: (node, next) ->
        
        # Adding the class 'off' sets the opacity to 0 so it starts
        # invisible. We have to insert the node before 'next'
        $(node).addClass('off').insertBefore(next)

        # Tracker.afterFlush is run after all the autoruns have 
        # been re-run (Tracker used to be called Deps). Don't
        # worry too much about what this means
        Tracker.afterFlush ->
          
          # Removing the class off means opacity is no longer 0,
          # and instead will be 1. The .fade CSS rule makes it so 
          # it takes 200ms to go from 0 to 1, giving a fade effect.
          $(node).removeClass('off')

      removeElement: (node) ->
          
          # These are events that are triggered at the end
          # of a CSS transition - there are a lot because 
          # we are taking into account all the different browsers
          finishEvent = 'webkitTransitionEnd 
            oTransitionEnd 
            transitionEnd 
            msTransitionEnd 
            transitionend'

          console.log finishEvent
     
          # Adding the class off changes the opacity back to 0.
          $(node).addClass('off')
          
          # Here we wait for the browser to trigger one of the 
          # finish events listed above. Once it does this we know
          # it's safe to remove it from the DOM
          $(node).on finishEvent, ->
            $(node).remove()
    }
  
  Template.buttons.events
    'click .js-create-game': () ->
      Games.insert({title: 'game ' + (Games.find().count() + 1)})
      
    'click .js-remove-game': () ->
      # Removes random game
      Games.remove({_id: Games.find().fetch()[Random.choice(_.range(0,Games.find().count()-1))]._id})