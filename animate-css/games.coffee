@Games = new Mongo.Collection('games')

if Meteor.isClient

  ONSCREN_CLASS = 'bounceInLeft'
  OFFSCREEN_CLASS = 'bounceOutLeft'
  EVENTS = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend'
   
  hooks = {
    insertElement: (node, next) ->
      $(node)
        .addClass(ONSCREN_CLASS)
        .insertBefore(next)
      
      Deps.afterFlush ->
        $(node).removeClass(OFFSCREEN_CLASS)
   
    removeElement: (node) ->
      $(node)
        .removeClass(ONSCREN_CLASS)
        .addClass(OFFSCREEN_CLASS)
        .one EVENTS, ->
          console.log 'end'
          $(node).remove()
  }
   
  Template.transition.rendered = ->
    this.firstNode.parentNode._uihooks = hooks
  

  # Boring stuff
  Template.buttons.events
    'click .js-create-game': () ->
      Games.insert({title: 'game ' + (Games.find().count() + 1)})
      
    'click .js-remove-game': () ->
      # Removes random game
      Games.remove({_id: Games.find().fetch()[Random.choice(_.range(0,Games.find().count()-1))]._id})

  Template.games.helpers
    games: () ->
      Games.find()