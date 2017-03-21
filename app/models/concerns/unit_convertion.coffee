define [
  'mathjs'
], (
  mathjs
) ->
  round = (value, decimals) ->
    Number(Math.round(value + 'e' + decimals) + 'e-' + decimals) or null

  get: (name, attrs) ->
    if !attrs[name] or
      _.include([0, 1], @personal_property.property_units.length) or
      !@get('property_unit_id')

        return round(attrs[name], 2)

    saveUnit = @personal_property.get('save_unit').short_name
    unit = mathjs.unit("#{attrs[name]} #{saveUnit}")
    value = unit.toNumber(@get('property_unit_name'))
    round(value, 2)

  set: (name, value, attrs) ->
    if !value or
      _.include([0, 1], @personal_property.property_units.length) or
      !@get('property_unit_id')

        return attrs[name] = round(value, 2)

    saveUnit = @personal_property.get('save_unit').short_name
    unit = mathjs.unit("#{value} #{@get('property_unit_name')}")
    newValue = unit.toNumber(saveUnit)
    attrs[name] = round(newValue, 2)
