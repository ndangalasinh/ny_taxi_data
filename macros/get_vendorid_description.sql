{# This macro will give the description of the vendor id#}
{% macro get_vendorid_description(vendorid) %}
    case
        {{ vendorid }}
        when 1
        then 'Creative Mobile Technologies, LLC;'
        when 2
        then 'VeriFone Inc.'
    end
{% endmacro %}
