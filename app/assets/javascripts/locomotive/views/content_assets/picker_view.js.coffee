#= require ../shared/asset_picker_view

Locomotive.Views.ContentAssets ||= {}

class Locomotive.Views.ContentAssets.PickerView extends Locomotive.Views.Shared.AssetPickerView

  number_items_per_row: 4

  _item_views: []

  template: ->
    ich.content_asset_picker

  fetch_assets: ->
    @collection.fetch()

  build_uploader: (el, link) ->
    window.LocomotiveUploadify.build el,
      url:        link.attr('href')
      data_name:  el.attr('name')
      height:     link.outerHeight()
      width:      link.outerWidth()
      file_ext:   '*.png;*.gif;*.jpg;*.jpeg;*.pdf;*.doc;*.docx;*.xls;*.xlsx;*.txt;*.zip'
      success:    (model) => @collection.add(model)
      error:      (msg)   => @shake()

  add_asset: (asset) ->
    view = new Locomotive.Views.ContentAssets.PickerItemView model: asset, parent: @

    (@_item_views ||= []).push(view)
    @$('ul.list .clear').before(view.render().el)

    @_refresh() & @_move_to_last_asset()

  remove_asset: (asset) ->
    view = _.find @_item_views, (tmp) -> tmp.model == asset
    view.remove() if view?
    @_refresh()

  _on_refresh: ->
    self = @
    @$('ul.list li.asset').each (index) ->
      if (index + 1) % self.number_items_per_row == 0
        $(@).addClass('last')
      else
        $(@).removeClass('last')

  _reset: ->
    _.each @_item_views || [], (view) -> view.remove()
    super()